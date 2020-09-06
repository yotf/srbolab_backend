from db import db

#= CLASS ===============================
# korisnik
#=======================================
class korisnik:

    #= METHOD ==============================
    # __init__
    #=======================================
    def __init__(self):

        self.schema = 'sys'
        self.name = 'korisnik'
        self.col_names, self.col_types = db.tbl_cols_arr(self.schema, self.name)

    #= METHOD ==============================
    # kr_get
    #=======================================
    def kr_get(self,
             pn_kr_insertd=None,
             pc_kr_ime=None,
             pc_kr_prezime=None,
               pc_kr_username=None,
               pc_kr_password=None,
             pc_kr_insertp=None,
             pc_kr_aktivan=None):
        """  Get data; Returns json object"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vx_res = None
        try:
            crsr.callproc(
                'sys.f_korisnik_g',
                [pn_kr_insertd, pc_kr_naziv, pc_kr_naziv_l, pc_kr_insertp, pc_kr_aktivna])
            vx_res = js.dumps([dict(r) for r in crsr])
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vx_res

    #= METHOD ==============================
    # kr_insert
    #=======================================
    def kr_insert(self, pc_rec):
        """  Insert data; Returns new kr_insertd"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_korisnik_i', [pc_rec])
            vn_res = crsr.fetchone()['f_korisnik_i']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vn_res

    #= METHOD ==============================
    # kr_update
    #=======================================
    def kr_update(self, pc_rec):
        """  Update data; Returns number of records updated"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_korisnik_u', [pc_rec])
            vn_res = crsr.fetchone()['f_korisnik_u']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vn_res

    #= METHOD ==============================
    # kr_delete
    #=======================================
    def kr_delete(self, pn_kr_insertd):
        """  Delete data; Returns number of records deleted"""

        conn = db.get_connection()
        crsr = conn.cursor()
        vn_res = -1
        try:
            crsr.callproc('sys.f_korisnik_d', [pn_kr_insertd])
            vn_res = crsr.fetchone()['f_korisnik_d']
            if vn_res:
                conn.commit()
        except:
            raise
        finally:
            crsr.close()
            db.return_connection(conn)

        return vn_res


