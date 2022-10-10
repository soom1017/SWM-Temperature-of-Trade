from typing import List
from defusedxml import DTDForbidden
from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db import schemas

keywords = APIRouter()

@keywords.get('/map/{keyword_name}', response_model=List[schemas.News])
async def get_graph_map_by_keyword_name(keyword_name: int, db: Session = Depends(get_db)):
    """
    1. search keyword from Keyword DB (GRAPH DB)
    2. if exists, show graph in DB
       else, execute `keywordcrawler.py` to scrap map info. from https://data.kostat.go.kr/social/keyword/
             then show graph in DB
    """
    pass