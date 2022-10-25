from pydantic import BaseModel

class AuthData(BaseModel):
    uid: str
    access_token: str
    
class FilterData(BaseModel):
    keywords: list
    stocks: list