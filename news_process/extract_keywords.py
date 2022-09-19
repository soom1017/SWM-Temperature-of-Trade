import sys
import pandas as pd

from config import config
from utils.keywordextractor import ToTTfidfVectorizer

NEWS_DATA_PATH = config.SAMPLE_NEWS_DATA_PATH
ARTICLE_PATH = sys.argv[1]
NUM_KEYWORD = sys.argv[2]

df = pd.read_csv(NEWS_DATA_PATH)
sample_articles = df['본문']

with open(ARTICLE_PATH, 'r') as f:
    article = f.read()

vectorizer_ = ToTTfidfVectorizer()
vectorizer_.fit(sample_articles)
keywords = vectorizer_.get_keyword_names(article, NUM_KEYWORD)