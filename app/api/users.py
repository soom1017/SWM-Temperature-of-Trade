from logging import Logger
from typing import List
from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session
from app.config import oauthsettings
from app.util.models import AuthData
from app.db import models, schemas
from app.db.database import get_db

import requests
import firebase_admin
from firebase_admin import auth, credentials

FIREBASE_CERT_PATH = oauthsettings.FIREBASE_CERT_PATH
KAKAO_URI = "https://kapi.kakao.com/v1/user/access_token_info"

if not firebase_admin._apps:
    cred = credentials.Certificate(FIREBASE_CERT_PATH)
    app = firebase_admin.initialize_app(cred)

users = APIRouter()

# Register / Login
@users.post('/auth/kakao')
async def kakao_auth_request(uid: str, db: Session = Depends(get_db)):

    # authorized user, but not signed up
    user = db.query(models.User).filter(models.User.id == uid).first()
    if not user:
        new_user = models.User(id=uid)
        db.add(new_user)
        db.commit()
        # add to firebase
        auth.create_user()
    
    # finish sign-in    
    auth.get_user(uid, app)
    custom_token = auth.create_custom_token(uid, app=app)
    return custom_token.decode('utf-8')

@users.get('/{authData}/bookmarks', response_model=schemas.NewsOut)
async def get_user_bookmark_news(authData: AuthData, db: Session = Depends(get_db)):
    headers = {'Authorization': f'Bearer {authData.access_token}'}
    res = requests.get(KAKAO_URI, headers=headers)
    if res.status_code != 200:
        raise HTTPException(404, detail="Token is not valid")
    
    user = db.query(models.User).filter(models.User.id == authData.user_id).first()
    if user == None:
        raise HTTPException(404, detail="User not found")

    return {"data": user.news}
