#### Import Modules
import sys

from regex import P
#sys.setdefaultencoding('utf8')
PATH = "./crawling_data"
import pdb
import os
import pymysql as pm
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from news_process.utils.summarygenerator import SummaryGenerator
from news_process.sentiment_classifier import SentimentClassifier
from news_process.utils.keywordextractor import ToTTfidfVectorizer
from data_collect.Crawler_mk import Crawling
from transformers import logging as hf_logging
from server_process.get_top import get_top_news_list

hf_logging.set_verbosity_error()
#### Init Modules
### Init SummaryGenerator & Highlight Indexer
generator_ = SummaryGenerator()

### Init KeywordExtractor
vectorizer_ = ToTTfidfVectorizer()

### Init SentimentAnalysis
classifier = SentimentClassifier()

### Init MySql Conenction
conn = pm.connect(host='docker_db_1', user='root', password='password', db='yetti', charset='utf8')
db=conn.cursor()
news_insert = 'INSERT IGNORE INTO news (id, title, body, reporter,press,created_at,highlight_idx,summary,label,score) VALUES (%s, %s, %s, %s, %s, %s, %s,%s,%s,%s);'
news_keyword_insert = 'INSERT IGNORE INTO news_keywords (news_id,keyword_name) VALUES(%s, %s)'
keyword_insert = 'INSERT IGNORE INTO keyword (name) VALUES (%s);'

### Init Crawler
with open(PATH, 'w') as f:
    start = f.read()

### Init Variables
## Use for get_top_news_lit
count=0

#### Execute Modules

### Crawling Articles
Data=Crawling(start)
### Not Crawlled
if len(Data)==0:
    sys.exit(0)


article=Data['Body']
title=Data['Title']
idx=Data['News_Idx']
reporter=Data['Reporter']
created=Data['Created']
raw=Data['Raw']



### Summary Generator
for i in range(len(Data)):
    try:
        summary = generator_.get_summary(article[i])
    except:
        continue
### Highlight Indexor
##/ToT/news_process/utils/summarygenerator.py", line 105 줄에서 에러있음
## The truth value of an array with more than one element is ambiguous(?)
    highlight_indexes = generator_.get_highlight_indexes()
### Keyword Extractor
    vectorizer_.fit(article[i])
    keywords = vectorizer_.get_keyword_names(article[i], 3)
### Sentiment Analysis
    label=classifier.get_sentiment(title[i])
### Execute SQL Queries
    news_insert = 'INSERT INTO news (id, title, body, reporter,press,created_at,highlight_idx,summary,label,score) VALUES (%s, %s, %s, %s, %s, %s, %s,%s,%s,%s);'
    db.execute(news_insert,(idx[i],title[i],str(generator_.sentences),reporter[i],"매일경제",created[i],str(highlight_indexes)  ,summary,label['label'][-1],label['score']))

    for j in keywords:
        db.execute(keyword_insert,(j))
        db.execute(news_keyword_insert,(idx[i],j))
    conn.commit()    
    count+=1
    if count==10:    
        get_top_news_list(db)
        conn.commit()
        count=0

f.write(str(idx[i]+'\n'))
f.close()

conn.close()

