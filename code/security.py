from procedures.users import user_service

def authenticate(username, password):
    user = user_service.tbl_g(username=username)
    if user and user.password == password:
        return user


def identity(payload):
    user_id = payload["identity"]
    return user_service.tbl_g(kr_id=user_id)
