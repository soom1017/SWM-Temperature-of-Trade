from pydantic import BaseModel

class AuthData(BaseModel):
    isKakao: bool
    uid: str
    access_token: str
    fcm_token: str
    
class FilterData(BaseModel):
    keywords: list
    stocks: list