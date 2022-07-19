import requests
from pandas import DataFrame
from bs4 import BeautifulSoup
import re
from datetime import datetime
import os
import pdb
from time import sleep
import pandas as pd
import csv
class article:
    def __init__(self, title, summary, author, time, article, paragraph,url):
        self.title=title
        self.summary=summary
        self.author=author
        self.create=time[0]
        self.modify=time[-1]
        self.article=article
        self.paragraph=paragraph
        self.url=url
        self.sum=sum

    def display(self):
        print(self.title)
        print(self.summary)
        print(self.author)
        print(self.create)
        print(self.modify)
        print(self.article)
        print(self.paragraph)
        print(self.url)




headers = {
"User-Agent":
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
}
page=0
news_list=[]
art_list=[]
for page in range(0,10):
    url="https://www.mk.co.kr/news/economy/?page="+str(page)
    r = requests.get(url, headers=headers)
    bs=BeautifulSoup(r.content,'html.parser')
    arr=bs.findAll("dt","tit")
    for i in arr:
        news_list.append(i.find('a')['href'])
count=0
for news in news_list:
    try:
        r = requests.get(news, headers=headers)
        r.encoding='utf-8'
        bs=BeautifulSoup(r.content,'html.parser')
        bs = BeautifulSoup(r.content.decode('euc-kr','replace'),'html.parser')
        temp=bs.find("div","art_txt")
        if temp.find("span"):
            if "연합뉴스" in temp.find("span").text:
                continue
        title=bs.find("h1","top_title").text
        if '[표]' in title:
            continue
        if '[포토]' in title:
            continue
        if '[게시판]' in title:
            continue
        if '[외환]' in title:
            continue
        sum=bs.find("h2","sub_title1_new").findAll(text=True)
        kk=bs.find("div","art_txt").findAll(text=True)
        kk=[i for i in kk if i != '\n']
        kk.pop(0)
        for i in range(len(kk)):
            kk[i]=kk[i].replace('\r',"")
        kk=kk[:-4]
        result=""
        paragraph=[]
        for i in kk:
            if "googletag" not in i:
                result+=i+" "
                paragraph.append(i)
        summary=""
        for i in sum:
            summary+=(i+" ")
        author=bs.find("li","author")
        main_author=author.text
        time=bs.find("li","lasttime").text.split('\xa0')
        art=result
        try:
            fig=bs.findAll("figcaption")
            for i in fig:
                art=art.replace(i.text,"")
                for j in range(len(paragraph)):
                    paragraph[j] = paragraph[j].replace(i.text,"")
        except:
            pass
        # paragraph=art.split("\r")
        # for i in range(len(paragraph)):
            # paragraph[i]=paragraph[i].replace("\n","")
        if paragraph:
            # temp=paragraph.pop()
            # art=art.replace(temp,"")
            # art=result
            art_list.append(article(title,summary,main_author,time,art,paragraph,news))
            count+=1
            print(art_list[-1].title)
        if count==29:
            pdb.set_trace()
    except Exception as e:
        print(e)
        print(news)
# pdb.set_trace()
data = pd.DataFrame([(i.title,i.summary,i.author,i.create,i.modify,i.article,i.url,{j : i.sum[j] for j in range(len(i.sum))},{j:i.paragraph[j] for j in range(len(i.paragraph))}) for i in art_list ],columns=['제목','요약','기자','입력시간','최종변경시간','기사 전문','URL','요약(분리버전)','전문(분리버전)'])
data.to_csv('C:\\Users\\seo\\Desktop\\result.csv',encoding="utf-8-sig",index=False)
