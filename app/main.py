from fastapi import FastAPI

from app.db.database import engine, Base

from app.api.users import users
from app.api.news import news
from app.api.keywords import keywords

Base.metadata.create_all(bind=engine)
    
app = FastAPI()

app.include_router(users, prefix="/users")
app.include_router(news, prefix="/news")
app.include_router(keywords, prefix="/keywords")
        
@app.get("/")
def index():
    return "Hello World!"