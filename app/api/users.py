from typing import List
from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session
from app.config import oauthsettings
from app.util.models import AuthData
from app.db import models, schemas
from app.db.database import get_db

KAKAO_REST_API_KEY = oauthsettings.KAKAO_REST_API_KEY
KAKAO_REDIRECT_URI = oauthsettings.KAKAO_REDIRECT_URI

users = APIRouter()

# Register / Login
# @users.post('/auth/kakao')
# async def kakao_auth_request(authdata: AuthData):
#     # user = db.query(models.User).filter(models.User.)
#     raise HTTPException(status_code=404, detail="User Not Found")


# @users.put('/{username}/token/{access_token}/favorite-stocks/{stock_ids}/update/')
# async def update_favorite_stocks(username: str, access_token: int, stock_ids: List[int], db: Session = Depends(get_db)):
#     user = db.query(models.User).filter(models.User.name == username).first()
#     raise HTTPException(status_code=404, detail="User Not Found")
