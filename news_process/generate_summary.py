import sys
from utils.summarygenerator import SummaryGenerator

ARTICLE_PATH = sys.argv[1]
with open(ARTICLE_PATH, 'r') as f:
    article = f.read()

generator_ = SummaryGenerator()
summary = generator_.get_summary(article)
highlight_indexes = generator_.get_highlight_indexes()
