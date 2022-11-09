import time
import os
from app.config import settings

# get `hot news/keyword rank` update time
def get_update_time(context: str):
    paths = {"news": settings.HOT_NEWSLIST_PATH, "keyword": settings.HOT_KEYWORD_PATH}
    file_path = paths[context]
    
    update_time = time.ctime(os.path.getmtime(file_path))
    return update_time
    