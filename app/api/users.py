from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.util.models import AuthData
from app.db.models import User
from app.db.schemas import NewsParsed
from app.config import oauthsettings
from app.crud.news import get_one_news_by_id
from app.crud.users import get_one_user_by_token, create_new_user, get_uid_from_token

import requests
import firebase_admin
from firebase_admin import auth, credentials

FIREBASE_CERT_PATH = oauthsettings.FIREBASE_CERT_PATH
KAKAO_URI = "https://kapi.kakao.com/v1/user/access_token_info"

if not firebase_admin._apps:
    cred = credentials.Certificate(FIREBASE_CERT_PATH)
    app = firebase_admin.initialize_app(cred)
    
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

users = APIRouter()

# Register / Login
@users.post('/auth/kakao')
async def kakao_auth_request(authData: AuthData, db: Session = Depends(get_db)):
    # get kakao-authorization
    headers = {'Authorization': f'Bearer {authData.access_token}'}
    res = requests.get(KAKAO_URI, headers=headers)
    if res.status_code != 200:
        raise HTTPException(400, detail="Token is not valid")
    
    # add kakao-authorized user
    db_user = db.query(User).filter(User.uid == authData.uid).first()
    if not db_user:
        create_new_user(authData.uid, db)
        auth.create_user(uid=authData.uid)
    
    # finish sign-in    
    auth.get_user(authData.uid, app)
    custom_token = auth.create_custom_token(authData.uid, app=app)
    return custom_token.decode('utf-8')

@users.get('/auth/guest')
async def guest_auth_request(db: Session = Depends(get_db)):
    # add arbitrary user
    user = auth.create_user()
    create_new_user(user.uid, db)
    auth.create_user(uid=user.uid)
    
    # finish sign-in
    auth.get_user(user.uid, app)
    custom_token = auth.create_custom_token(user.uid, app=app)
    return custom_token.decode('utf-8')
    
@users.get('/auth/etc')
async def auth_request(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    # validate id-token, finish sign-in
    uid = get_uid_from_token(token)
    db_user = db.query(User).filter(User.uid == uid).first()
    if not db_user:
        create_new_user(uid, db)

@users.get('/bookmarks')
async def get_user_bookmark(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    bookmark_news_list = db_user.news
    
    data = []
    for news in bookmark_news_list:
        data.append(NewsParsed(news))
    return {"data": data}

@users.get('/create/bookmark/{news_id}', status_code=201)
async def create_user_bookmark(news_id: int, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    db_news = get_one_news_by_id(news_id, db)
    
    db_user.news.append(db_news)
    db.commit()
    
@users.get('/delete/bookmark/{news_id}')
async def create_user_bookmark(news_id: int, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    db_news = get_one_news_by_id(news_id, db)
    
    db_user.news.remove(db_news)
    db.commit()