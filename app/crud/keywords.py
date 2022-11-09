from fastapi import Depends

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import Keyword, Stock

def get_all_keywords(db: Session = Depends(get_db)):
    keywords = db.query(Keyword.name).all()
    keywords = [k[0] for k in keywords]
    stocks = db.query(Stock.name).all()
    stocks = [s[0] for s in stocks]
    return keywords, stocks
    