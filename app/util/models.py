from pydantic import BaseModel

class AuthData:
    client_id: str
    access_token: str