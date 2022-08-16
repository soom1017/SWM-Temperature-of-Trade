import requests
from pandas import DataFrame
import pandas as pd
from bs4 import BeautifulSoup
import re
from datetime import datetime
import os
import pdb
from time import sleep
headers = {
"User-Agent":
"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36"
}
values = { 'where':'news',
            'sort': '0',
          'photo': '3',
          'field': '0',
          'pd': '3',
          'ds': '2022.05.15',
          'de': '2022.08.15',
          'query':'네이버',
          'cluster_rank':'60',
          'mynews':'1',
          'office_type':'1',
          'office_section_code':'3',
          'news_office_checked':'1009',
          'is_sug_officeid':'0',
          'start':'1'
          }
ds_list=['2018.02.15','2018.08.15','2019.02.15','2019.08.15','2020.02.15','2020.08.15','2021.02.15','2021.08.15','2022.02.15']
de_list=['2018.08.15','2019.02.15','2019.08.15','2020.02.15','2020.08.15','2021.02.15','2021.08.15','2022.02.15','2022.08.15']
class article:
    def __init__(self, title, summary, author, time, article, paragraph,url,sentence,scnt,keyword):
        self.title=title
        self.summary=summary
        self.author=author
        self.create=time[0]
        self.modify=time[-1]
        self.article=article
        self.paragraph=paragraph
        self.url=url
        self.sum=sum
        self.sentence=sentence
        self.scnt=scnt
        self.keyword=keyword
    def display(self):
        print(self.title)
        print(self.summary)
        print(self.author)
        print(self.create)
        print(self.modify)
        print(self.article)
        print(self.paragraph)
        print(self.url)

class Url:
    def __init__(self,keyword,title,link):
        self.keyword=keyword
        self.title=title
        self.url=link
url="https://search.naver.com/search.naver"
keyword="네이버"
key_list=['카카오','네이버','삼성전자','SK하이닉스','샐트리온']
url_list=[]
art_list=[]
count=0
for key in key_list:
    for t in range(len(ds_list)):
        values['ds']=ds_list[t]
        values['de']=de_list[t]
        for start in range(1,40,10):
            values["start"]=str(start)
            values['query']=keyword
            r= requests.get(url, params=values, headers=headers)
            bs = BeautifulSoup(r.content,"html.parser")
            art=bs.findAll("ul",{"class":"list_news"})
            a=art[0].findAll("li",{"class":"bx"})
            # pdb.set_trace()
            for i in a:
                c=i.find("a",{"class":"news_tit"})
                # print(c['title'])
                url_list.append(Url(key,c['title'],c['href']))
for news_info in url_list:
    try:
        # pdb.set_trace()
        r = requests.get(news_info.url, headers=headers)
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
        summary=""
        for i in sum:
            summary+=(i+" ")
        author=bs.find("li","author")
        main_author=author.text
        time=bs.find("li","lasttime").text.split('\xa0')
        art=bs.find("div","art_txt").text
        try:
            fig=bs.findAll("figcaption")
            for i in fig:
                art=art.replace(i.text,"")
        except:
            pass
        paragraph=art.split("\r")
        for i in range(len(paragraph)):
            paragraph[i]=paragraph[i].replace("\n","")
        if paragraph:
            temp=paragraph.pop()
            art=art.replace(temp,"")
            sentence=''.join(paragraph)
            sentence=sentence.split('.')
            new_sentence=[]
            for i in range(len(paragraph)):
                new_paragraph=[]
                sentence=paragraph[i].split('.',-1)
                while sentence:
                    result=sentence.pop(0)
                    if result=='':
                        continue
                    while result[-1].isnumeric():
                        result+='.'+sentence.pop(0)
                    if result=='' or result ==' ':
                        continue
                    new_paragraph.append(result)
                new_sentence.append(new_paragraph)
            s_cnt=0
            for i in new_sentence:
                for j in range(len(i)):
                    if i[j][-1].isalpha():
                        i[j]+='.'
                s_cnt+=len(i)
            # pdb.set_trace()
            art_list.append(article(title,summary,main_author,time,art,paragraph,news_info.url,new_sentence,s_cnt,news_info.keyword))
            count+=1
            # print(art_list[-1].title)
    except Exception as e:
        print(e)
        # pdb.set_trace()
        print(news_info)
data = pd.DataFrame(
                        [(i.title,i.summary,i.author,i.create,i.keyword,i.article,i.url,
                        {j : i.sum[j] for j in range(len(i.sum))},
                        {j:i.paragraph[j] for j in range(len(i.paragraph))},
                        {j:i.sentence[j] for j in range(len(i.sentence))},i.scnt)
                         for i in art_list ],columns=['제목','요약','기자','입력시간','키워드','기사 전문','URL','분리(요약)','분리(문단)','분리(문장)','문장수'])
data.to_csv('C:\\Users\\SeoHyeongSeoksCOM\\Desktop\\result.csv',encoding="utf-8-sig",index=False)
