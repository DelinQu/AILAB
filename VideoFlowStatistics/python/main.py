#静态
#-*- coding: utf-8 -*-
#!/usr/bin/env python

import urllib
import base64
import json
import time
from flask import Flask


#client_id 为官网获取的AK， client_secret 为官网获取的SK
#client_id =【百度云应用的AK】
#client_secret =【百度云应用的SK】

#获取token
def get_token():
    host = 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=你的key&client_secret=你的secret'
    request = urllib.request.Request(host)
    request.add_header('Content-Type', 'application/json; charset=UTF-8')
    response = urllib.request.urlopen(request)
    token_content = response.read()
    if token_content:
        token_info = json.loads(token_content)
        token_key = token_info['access_token']
        print(token_info)
    return token_key


#保存图片
def save_base_image(img_str, filename):
    img_data = base64.b64decode(img_str)
    with open(filename, 'wb') as f:
        f.write(img_data)


#人流量统计
#filename:原图片名（本地存储包括路径）；resultfilename:处理后的文件保存名称(每个人打标)
def body_num(filename, resultfilename):
    request_url = "https://aip.baidubce.com/rest/2.0/image-classify/v1/body_num"

# 二进制方式打开图片文件
f = open(filename, 'rb')
img = base64.b64encode(f.read())

params = dict()
params['image'] = img
params['show'] = 'true'
params = urllib.parse.urlencode(params).encode("utf-8")
# params = json.dumps(params).encode('utf-8')

access_token = get_token()
request_url = request_url + "?access_token=" + access_token
request = urllib.request.Request(url=request_url, data=params)
request.add_header('Content-Type', 'application/x-www-form-urlencoded')
response = urllib.request.urlopen(request)
content = response.read()
if content:
    # print(content)
    content = content.decode('utf-8')
    # print(content)
    data = json.loads(content)
    # print(data)
    person_num = data['person_num']
    print('person_num', person_num)
    img_str = data['image']
    save_base_image(img_str, resultfilename)

