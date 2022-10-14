from fastapi import Depends, HTTPException

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import News

def get_one_news_by_id(news_id: int, db: Session = Depends(get_db)):
    news = db.query(News).filter(News.id == news_id).first()
    if not news:
        raise HTTPException(status_code=404, detail="News not found")
    return news