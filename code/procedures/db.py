# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports __future__
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#from __future__ import print_function
#from __future__ import division
#from __future__ import unicode_literals
#from __future__ import absolute_import

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import re
import sys
import json as js
import psycopg2
import psycopg2.extras
from psycopg2 import pool
from box import SBox as dd


#---------------------------------------
# global variables
#---------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# pgdb
#=======================================
class pgdb:

    #= METHOD ==============================
    # __init__
    #=======================================
    def __init__(self):

        self.dsn = 'user=postgres password=geometar host=127.0.0.1 port=5432 dbname=srbolab'
        self.ccpool()

    #= METHOD ==============================
    # __del__
    #=======================================
    def __del__(self):
        """  Close connection pool"""

        if (self.cpool):
            self.cpool.closeall()

    #= METHOD ==============================
    # ccpool
    #=======================================
    def ccpool(self):
        """  Create connection pool"""

        try:
            self.cpool = psycopg2.pool.SimpleConnectionPool(
                1, 20, self.dsn, cursor_factory=psycopg2.extras.RealDictCursor)
        except (Exception, psycopg2.DatabaseError) as error:
            print('Error while connecting to PostgreSQL', error)

    #= METHOD ==============================
    # connget
    #=======================================
    def connget(self):
        """  Get connection from connection pool"""

        return self.cpool.getconn()

    #= METHOD ==============================
    # connret
    #=======================================
    def connret(self, po_conn):
        """  Return connection to connection pool"""

        self.cpool.putconn(po_conn)

    #= METHOD ==============================
    # tbl_cols_arr
    #=======================================
    def tbl_cols_arr(self, pc_schema, pc_table):
        """  Get column names/types for table in schema"""

        conn = self.connget()
        crsr = conn.cursor()
        lcl_col_nt = []
        try:
            crsr.callproc('f_tbl_cols_nt_arr', [pc_schema, pc_table])
            vcl_res = crsr.fetchone()['f_tbl_cols_nt_arr']
            lcl_col_nt = [s.split(',') for s in vcl_res.split('#')]
        except:
            raise
        finally:
            crsr.close()
            self.connret(conn)

        return lcl_col_nt

    #= METHOD ==============================
    # fmtrec
    #=======================================
    def fmtrec(self, pc_json, pl_cols):
        """  Format json object as row"""

        vcl_rec = None
        dxl_rec = js.loads(pc_json)[0]
        lcl_rec = []
        for vcl_col in pl_cols:
            vxl_col = dxl_rec[vcl_col]
            if isinstance(vxl_col, str):
                lcl_rec.append('"{}"'.format(vxl_col))
            else:
                lcl_rec.append('{}'.format(vxl_col))
        vcl_rec = '({})'.format(','.join(lcl_rec))

        return vcl_rec


db = pgdb()


#= CLASS ===============================
# lokacija
#=======================================
class lokacija:

    #= METHOD ==============================
    # __init__
    #=======================================
    def __init__(self):

        self.schema = 'sys'
        self.name = 'lokacija'
        self.col_names, self.col_types = db.tbl_cols_arr(self.schema, self.name)

    #= METHOD ==============================
    # lk_g
    #=======================================
    def lk_g(self,
             pn_lk_id=None,
             pc_lk_naziv=None,
             pc_lk_naziv_l=None,
             pc_lk_ip=None,
             pc_lk_aktivna=None):
        """  Get data; Returns json object"""

        conn = db.connget()
        crsr = conn.cursor()
        vx_res = None
        try:
            crsr.callproc(
                'sys.f_lokacija_g',
                [pn_lk_id, pc_lk_naziv, pc_lk_naziv_l, pc_lk_ip, pc_lk_aktivna])
            vx_res = js.dumps([dict(r) for r in crsr])
        except:
            raise
        finally:
            crsr.close()
            db.connret(conn)

        return vx_res

    #= METHOD ==============================
    # lk_i
    #=======================================
    def lk_i(self, pc_rec):
        """  Insert data; Returns new lk_id"""

        conn = db.connget()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_lokacija_i', [pc_rec])
            vn_res = crsr.fetchone()['f_lokacija_i']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.connret(conn)

        return vn_res

    #= METHOD ==============================
    # lk_u
    #=======================================
    def lk_u(self, pc_rec):
        """  Update data; Returns number of records updated"""

        conn = db.connget()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_lokacija_u', [pc_rec])
            vn_res = crsr.fetchone()['f_lokacija_u']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.connret(conn)

        return vn_res

    #= METHOD ==============================
    # lk_d
    #=======================================
    def lk_d(self, pn_lk_id):
        """  Delete data; Returns number of records deleted"""

        conn = db.connget()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_lokacija_d', [pn_lk_id])
            vn_res = crsr.fetchone()['f_lokacija_d']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.connret(conn)

        return vn_res


#= FUNCTION ============================
# t00
#=======================================
def t00():

    t = lokacija()
    print('# {}'.format('Table schema, name, column names, column types'))
    print('  Table schema: {}; name: {}; column names: {}; column types: {}'.
          format(t.schema, t.name, t.col_names, t.col_types))

    # get all
    print('\n# {}'.format('get all'))
    res = t.lk_g()
    print('  {}'.format(res))

    # insert ...
    print('\n# {}'.format('insert new record'))
    vcl_json = '[{{"lk_id": {}, "lk_naziv": "Нови Сад", "lk_naziv_l": "Новом Саду", "lk_ip": "192.168.1.{}", "lk_aktivna": "{}"}}]'.format(
        0, '55', 'D')
    res = t.lk_i(db.fmtrec(vcl_json, t.col_names))
    vnl_lk_id = res
    print('  New id: {}'.format(vnl_lk_id))
    # get lk_id=new lk_id
    print('# {}'.format('get new record'))
    res = t.lk_g(vnl_lk_id)
    print('  {}'.format(res))

    # update lk_id=new lk_id
    print('\n# {}'.format('update new record'))
    vcl_json = '[{{"lk_id": {}, "lk_naziv": "Нови Сад", "lk_naziv_l": "Новом Саду", "lk_ip": "192.168.1.{}", "lk_aktivna": "{}"}}]'.format(
        vnl_lk_id, '66', 'N')
    res = t.lk_u(db.fmtrec(vcl_json, t.col_names))
    print('  Updated records: {}'.format(res))
    # get lk_id=new lk_id
    print('# {}'.format('get updated new record'))
    res = t.lk_g(vnl_lk_id)
    print('  {}'.format(res))

    # delete lk_id=new lk_id
    print('\n# {}'.format('delete new record'))
    res = t.lk_d(vnl_lk_id)
    print('  Deleted records: {}'.format(res))
    # get lk_id=new lk_id
    print('# {}'.format('get new record'))
    res = t.lk_g(vnl_lk_id)
    print('  {}'.format(res))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# main code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if __name__ == '__main__':

    pass

    #---------------------------------------
    # global variables
    #---------------------------------------
    #---------------------------------------
    # code
    #---------------------------------------

    t00()
