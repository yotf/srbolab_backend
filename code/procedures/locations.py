from db import db

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
    # lk_get
    #=======================================
    def lk_get(self,
             pn_lk_insertd=None,
             pc_lk_naziv=None,
             pc_lk_naziv_l=None,
             pc_lk_insertp=None,
             pc_lk_aktivna=None):
        """  Get data; Returns json object"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vx_res = None
        try:
            crsr.callproc(
                'sys.f_lokacija_g',
                [pn_lk_insertd, pc_lk_naziv, pc_lk_naziv_l, pc_lk_insertp, pc_lk_aktivna])
            vx_res = js.dumps([dict(r) for r in crsr])
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vx_res

    #= METHOD ==============================
    # lk_insert
    #=======================================
    def lk_insert(self, pc_rec):
        """  Insert data; Returns new lk_insertd"""

        conn = db.get_connection()
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
            db.return_connection(conn)

        return vn_res

    #= METHOD ==============================
    # lk_update
    #=======================================
    def lk_update(self, pc_rec):
        """  Update data; Returns number of records updated"""

        conn = db.get_connection()
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
            db.return_connection(conn)

        return vn_res

    #= METHOD ==============================
    # lk_delete
    #=======================================
    def lk_delete(self, pn_lk_insertd):
        """  Delete data; Returns number of records deleted"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_lokacija_d', [pn_lk_insertd])
            vn_res = crsr.fetchone()['f_lokacija_d']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vn_res


