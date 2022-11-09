from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordBearer

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.util.models import AuthData, FilterData
from app.crud.news import get_one_news_by_id
from app.crud.users import get_one_user_by_token, update_user_fcm_token, kakao_auth_request, etc_auth_request, get_bookmarks_of, get_favorites_of, update_favorites_of

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

users = APIRouter()

# Register / Login
@users.post('/auth')
async def auth_request(authData: AuthData, db: Session = Depends(get_db)):
    uid, token, fcm_token = authData.uid, authData.access_token, authData.fcm_token
    if authData.isKakao:
        custom_token = kakao_auth_request(uid, token, fcm_token, db)
        return custom_token
    
    etc_auth_request(token, fcm_token, db)

# Notification
@users.patch('/notification')
async def toggle_notification_setting(fcm_token: str = '', token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    update_user_fcm_token(db_user, fcm_token)

# Bookmark
@users.get('/bookmarks')
async def get_user_bookmark(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    data = get_bookmarks_of(db_user)
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
    
# Favorite - Keyword, Stock
@users.get('/favorites')
async def get_user_favorites(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    favorites = get_favorites_of(db_user)
    return favorites

@users.patch('/favorites', status_code=204)
async def update_user_favorite(favorites: FilterData, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    db_user = get_one_user_by_token(token, db)
    update_favorites_of(db_user, favorites, db)
