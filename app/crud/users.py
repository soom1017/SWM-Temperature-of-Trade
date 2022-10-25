from fastapi import Depends, HTTPException

from sqlalchemy import insert, delete
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.util.models import FilterData
from app.db.models import User, user_keywords, user_stocks
from app.db.schemas import NewsParsed

from firebase_admin import auth

## auth
def get_uid_from_token(token:str):
    try:
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']
    except:
        raise HTTPException(400, detail="Token is not valid, or expired")
    return uid

## user
# get user
def get_one_user_by_token(token: str, db: Session = Depends(get_db)):
    uid = get_uid_from_token(token)
    db_user = db.query(User).filter(User.uid == uid).first()
    if not db_user:
        raise HTTPException(404, detail="User not found")
    return db_user

# create user
def create_new_user(uid: str, db: Session = Depends(get_db)):
    new_user = User(uid=uid)
    db.add(new_user)
    db.commit()
    
## user information
# bookmark
def get_bookmarks_of(db_user: User):
    bookmark_news_list = db_user.news
    
    data = []
    for news in bookmark_news_list:
        data.append(NewsParsed(news))
    return data

# favorite
def get_favorites_of(db_user: User):
    keyword_list = db_user.keyword
    stock_list = db_user.stock
    
    data = {
        "keywords": [keyword.name for keyword in keyword_list],
        "stocks": [stock.name for stock in stock_list]
    }
    return data

def update_favorites_of(db_user: User, new_favorites: FilterData, db: Session = Depends(get_db)):
    db_favorites = get_favorites_of(db_user)
    
    db_key, db_stock = set(db_favorites["keywords"]), set(db_favorites["stocks"])
    new_key, new_stock = set(new_favorites.keywords), set(new_favorites.stocks)
    
    for k in new_key.difference(db_key):
        statement = insert(user_keywords).values(user_id=db_user.id, keyword_name=k)
        db.execute(statement)
    for k in db_key.difference(new_key):
        statement = delete(user_keywords).where(user_keywords.c.user_id == db_user.id, user_keywords.c.keyword_name == k)
        db.execute(statement)
    
    for st in new_stock.difference(db_stock):
        statement = insert(user_stocks).values(user_id=db_user.id, stock_name=st)
        db.execute(statement)
    for st in db_stock.difference(new_stock):
        statement = delete(user_stocks).where(user_stocks.c.user_id == db_user.id, user_stocks.c.stock_name == st)
        db.execute(statement)
    
    db.commit()