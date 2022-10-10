from pydantic import BaseModel

class AuthData(BaseModel):
    uid: str
    access_token: str