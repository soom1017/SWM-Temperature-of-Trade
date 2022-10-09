from typing import List
from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session
from app.config import oauthsettings
from app.util.models import AuthData
from app.db import models, schemas
from app.db.database import get_db

import requests
import firebase_admin

FIREBASE_CERT_PATH = oauthsettings.FIREBASE_CERT_PATH

KAKAO_REST_API_KEY = oauthsettings.KAKAO_REST_API_KEY
KAKAO_REDIRECT_URI = oauthsettings.KAKAO_REDIRECT_URI
KAKAO_URI = "https://kapi.kakao.com/v1/user/access_token_info"

users = APIRouter()

# Register / Login
@users.post('/auth/kakao')
async def kakao_auth_request(authdata: AuthData, db: Session = Depends(get_db)):
    headers = {'Authorization': f'Bearer {authdata.access_token}'}
    res = requests.get(KAKAO_URI, headers=headers)
    
    if res.status_code == 200:
        # authorized user, but not signed up
        user = db.query(models.User).filter(models.User.id == authdata.uid).first()
        if not user:
            new_user = models.User(id=authdata.uid, access_token=authdata.access_token)
            db.add(new_user)
            db.commit()
        
        # finish sign-in    
        cred = firebase_admin.credentials.Certificate(FIREBASE_CERT_PATH)
        app = firebase_admin.initialize_app(cred, name='auth')

        firebase_admin.auth.get_user(authdata.uid, app)
        custom_token = firebase_admin.create_custom_token(authdata.uid, app=app)
        return custom_token.decode('utf-8')
    
    return HTTPException(status_code=401, detail="Token is not valid")

@users.get('/{user_id}/bookmarks', response_model=List[schemas.News])
async def get_user_bookmark_news(user_id: str, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user == None:
        raise HTTPException(404, detail="User not found")
    
    headers = {'Authorization': f'Bearer {user.access_token}'}
    res = requests.get(KAKAO_URI, headers=headers)
    if res.status_code != 200:
        raise HTTPException(404, detail="Token is not valid")
    
    return user.news
