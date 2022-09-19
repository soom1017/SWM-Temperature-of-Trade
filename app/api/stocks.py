from typing import List
from defusedxml import DTDForbidden
from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db import schemas

stocks = APIRouter()

@stocks.get('/list-kospi20/', response_model=List[schemas.StockBase])
async def get_stock_list(db: Session = Depends(get_db)):
    
    pass