from fastapi import Depends, HTTPException

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import User

from firebase_admin import auth

def get_uid_from_token(token:str):
    try:
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']
    except:
        raise HTTPException(400, detail="Token is not valid, or expired")
    return uid

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