import crypt

def hash_password(password: str):
    return crypt.crypt(password, crypt.METHOD_SHA512)
