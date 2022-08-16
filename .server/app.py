from flask import Flask, request
import pandas as pd
import json, math
from working import *
from news import *

response = ''

app = Flask(__name__)

@app.route('/job', methods = ['GET', 'POST'])
def jobRoute():

    global response

    #checking the request type we get from the app
    if(request.method == 'POST'):
        request_data = request.data #getting the response data
        request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
        job = request_data['job'] #assigning it to job

        for i in range(0,75,15): #loops through each page
            print(f'Getting page {math.floor((i/15)+1)}')
            if(job != ''):
                c = extract(job, 'nyc', 0) 
                transform(c)
            df = pd.DataFrame(jobList)
        return '' #to avoid a type error 
    else:
        data = json.dumps(jobList, indent=2)
        del jobList[:]
        return data #sending data back to your frontend app

@app.route('/news', methods = ['GET'])
def index():
    topNews()
    news = json.dumps(results, indent=2)
    del results[:]
    return news

            

if __name__ == "__main__":
    app.run(debug=True)