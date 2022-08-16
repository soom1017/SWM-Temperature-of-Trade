# 네이버 검색 API예제는 블로그를 비롯 전문자료까지 호출방법이 동일하므로 blog검색만 대표로 예제를 올렸습니다.
# 네이버 검색 Open API 예제 - 블로그 검색
import os
import sys
import urllib.request
import pdb
import json
from bs4 import BeautifulSoup as bs
import pandas as pd
import random
class Article:
    def __init__(self, title, description, keyword, pubdate, original,link):
        self.title=title
        self.description=description
        self.keyword=keyword
        self.pubDate=pubdate
        self.originallink=original
        self.link=link
client_id = "AmBAMrW0xPSKVJEeCaYm"
client_secret = "f7UqKOcFcU"
keyword='삼성전자'
encText = urllib.parse.quote(keyword)
sort=urllib.parse.quote("sim")
display=urllib.parse.quote("30")
start=1
link_list=[]
start_list=[x for x in range(1000,0,-25)]
print(start_list)
# keyword_list=['삼성전자(주) 사건','카카오(주) 사건','네이버(주) 사건','셀트리온(주) 사건','SK하이닉스(주) 사건']
keyword_list=['네이버(주) 사건']
for j in keyword_list:
    for start in start_list:
        encText = urllib.parse.quote(j)
        url = "https://openapi.naver.com/v1/search/news?query=" + encText +"&sort="+sort+"&display=" + display+"&start=" +str(start) # json 결과
        request = urllib.request.Request(url)
        request.add_header("X-Naver-Client-Id",client_id)
        request.add_header("X-Naver-Client-Secret",client_secret)
        response = urllib.request.urlopen(request)
        rescode = response.getcode()
        if(rescode==200):
            response_body = response.read()
            temp=response_body.decode('utf-8')
            # print(response_body.decode('utf-8'))
        else:
            print("Error Code:" + rescode)
        html = response.read()
        soup = bs(response_body, 'html.parser')
        t=json.dumps(temp,indent=4)
        jsonString = temp
        if(type(json.loads(jsonString)) == list):
            data = json.loads(jsonString)[0]
        elif(type(json.loads(jsonString)) == dict):
            data = json.loads(jsonString)

        for i in data['items']:
            if 'en.' in i['originallink'] or 'jp.' in i['originallink'] or 'japan' in i['originallink'] or 'us.' in i['originallink'] or 'koreatimes' in i['originallink'] or 'pulsenews' in i['originallink'] or 'koreajoongangdaily' in i['originallink']:
                continue
            new_Article=Article(i['title'],i['description'],j,i['pubDate'],i['originallink'],i['link'])
            link_list.append(new_Article)
data = pd.DataFrame([(i.title,i.description,i.keyword,i.pubDate,i.originallink,i.link) for i in link_list ],columns=['제목','설명','키워드','입력시간','기사링크','원본링크'])
data.to_csv('C:\\Users\\SeoHyeongSeoksCOM\\Desktop\\result.csv',encoding="utf-8-sig",index=False)
