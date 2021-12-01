import json
from operator import ne
from db import db
from db import Users
from db import Times
from db import Zipcodes
from flask import Flask
from flask import request
import requests
import math
import datetime
import os


app = Flask(__name__)
db_filename = "final.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

api_key = "6045a3db7be80feeff53eb7f6c53586d"


# your routes here


def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


def extract_token(request):
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return None
    bearer_token = auth_header.replace("Bearer ", "")
    if bearer_token is None or not bearer_token:
        return  None
    return bearer_token


#gets weather for a specific user with a specific zipcode for the day
@app.route("/api/users/weather/daily/")
def get_daily_weather():
    

    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("incorrect token", 401)
    user = Users.query.filter_by(session_token=session_token).first()
    zipcode = Zipcodes.query.filter_by(id=user.zipcode_id).first()


    url = f"http://api.openweathermap.org/data/2.5/weather?zip={zipcode.number},{zipcode.country_code}&appid={api_key}"

    response = requests.get(url).json()
    if 'message' in response and response['message'] == 'city not found':
        return failure_response('Invalid zipcode or country code')
    lon = response['coord']['lon']
    lat = response['coord']['lat']


    url1 = f"http://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=current,minutely,hourly,alerts&appid={api_key}"
    response1 = requests.get(url1).json()


    final_response = {}
    temp_morn = response1['daily'][1]['temp']['morn']
    temp_morn = math.floor((temp_morn * 1.8) - 459.67)
    temp_day = response1['daily'][1]['temp']['day']
    temp_day = math.floor((temp_day * 1.8) - 459.67)
    temp_eve = response1['daily'][1]['temp']['eve']
    temp_eve = math.floor((temp_eve * 1.8) - 459.67)
    temp_night= response1['daily'][1]['temp']['night']
    temp_night = math.floor((temp_night * 1.8) - 459.67)
    pop = response1['daily'][1]['pop']
    rain_possible = pops(pop)
    if 'rain' in response1['daily'][1]:
        rain_amount = response1['daily'][1]['rain']
    else:
        rain_amount = None
    if 'snow' in response1['daily'][1]:
        snow_amount = response1['daily'][1]['snow']
    else:
        snow_amount = None
    final_response['Morning Temp'] = temp_morn
    final_response['Day Temp'] = temp_day
    final_response['Evening Temp'] = temp_eve
    final_response['Night Temp'] = temp_night
    final_response['Chance of Precipitation'] = pop
    final_response['Message'] = rain_possible
    if bool(rain_amount):
        final_response['Rain Amount'] = rain_amount
    if bool(snow_amount):
        final_response['Snow Amount'] = snow_amount
    
    return success_response(final_response)


@app.route("/api/users/weather/hourly/")
def get_hourly_weather():

    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("incorrect token", 401)

    user = Users.query.filter_by(session_token=session_token).first()
    zipcode = Zipcodes.query.filter_by(id=user.zipcode_id).first()

    url = f"http://api.openweathermap.org/data/2.5/weather?zip={zipcode.number},{zipcode.country_code}&appid={api_key}"

    response = requests.get(url).json()
    if response['message'] == 'city not found':
        return failure_response('Invalid zipcode or country code')
    lon = response['coord']['lon']
    lat = response['coord']['lat']

    url1 = f"http://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=current,minutely,daily,alerts&appid={api_key}"
    response1 = requests.get(url1).json()

    final_response = {}

    if user.times is None:
        return failure_response("User has no valid times!")
        
    user_times = []
    for time in user.times:
        user_times.append(time.time)
        
    for time in response1['hourly']:
        if time['dt'] in user_times:
            final_response[time['dt']]=format_hourly_weather(time)
    return success_response(final_response)

def format_hourly_weather(hour):
    temp = hour['temp']
    temp = math.floor((temp * 1.8) - 459.67) 

    pop = hour['pop']
    rain_possible = pops(pop)
    if 'rain' in hour:
        rain_amount = hour['rain']['1h']
    else:
        rain_amount = None
    if 'snow' in hour:
        snow_amount = hour['snow']['1h']
    else:
        snow_amount = None

    final_response = {}
    final_response['Hourly Temp'] = temp
    final_response['Chance of Precipitation'] = pop
    final_response['Message'] = rain_possible
    if bool(rain_amount):
        final_response['Rain Amount'] = rain_amount
    if bool(snow_amount):
        final_response['Snow Amount'] = snow_amount

    return final_response

def pops(pop):
    if pop >= 0.8:
        rain_possible = "Very likely"
    elif pop >= 0.6:
        rain_possible = "Likely"
    elif pop >= 0.4:
        rain_possible = "Somewhat likely"
    elif pop >= 0.2:
        rain_possible = "Unlikely"
    else:
        rain_possible = "Clear Day"
    return rain_possible

@app.route("/api/users/weather/current/")
def get_current_hour_weather():
    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("incorrect token", 401)
    user = Users.query.filter_by(session_token=session_token).first()
    zipcode = Zipcodes.query.filter_by(id=user.zipcode_id).first()

    url = f"http://api.openweathermap.org/data/2.5/weather?zip={zipcode.number},{zipcode.country_code}&appid={api_key}"

    response = requests.get(url).json()
    if response['message'] == 'city not found':
        return failure_response('Invalid zipcode or country code')
    lon = response['coord']['lon']
    lat = response['coord']['lat']

    url1 = f"http://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=current,minutely,daily,alerts&appid={api_key}"
    response1 = requests.get(url1).json()
     

    finalresponse = {}
    temp = response1['hourly'][1]['temp']
    temp = math.floor((temp * 1.8) - 459.67)
    
    pop = response1['hourly'][1]['pop']
    rain_possible=pops(pop)
     
    if 'rain' in response1['hourly'][1]:
        rain_amount = response1['hourly'][1]['rain']['1h']
    else:
        rain_amount = None
    if 'snow' in response1['hourly'][1]:
        snow_amount = response1['hourly'][1]['snow']['1h']
    else:
        snow_amount = None
     

    final_response = {}
    final_response['Hourly Temp'] = temp
    final_response['Chance of Precipitation'] = pop
    final_response['Message'] = rain_possible
    if bool(rain_amount):
        final_response['Rain Amount'] = rain_amount
    if bool(snow_amount):
        final_response['Snow Amount'] = snow_amount
    return success_response(final_response)



@app.route("/api/users/")
def get_users():
    return success_response({"users": [t.serialize() for t in Users.query.all()]})


@app.route("/api/zipcodes/")
def get_zipcodes():
    return success_response({"zipcodes": [t.serialize() for t in Zipcodes.query.all()]})

#post contains username,password,zipcode
@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    username=body.get("username")
    password=body.get("password")
    zipcode=str(body.get("zipcode"))
    country_code = body.get("country_code", "US")
    if not username:
        return failure_response("Username is required", 400)
    if not password:
        return failure_response("Password is required", 400)
    if not zipcode:
        return failure_response("Zipcode is required", 400)
    if Zipcodes.query.filter_by(number=zipcode).first() is None:
        new_zipcode=Zipcodes(number=zipcode, country_code=country_code)
        db.session.add(new_zipcode)
        db.session.commit()
    if Users.query.filter_by(username=username).first() is not None:
        return failure_response("user already exists")
    zipcode_id=Zipcodes.query.filter_by(number=zipcode).first().id
    new_user = Users(username=username, password=password, zipcode_id=zipcode_id)
    db.session.add(new_user)
    db.session.commit()

    return success_response(
        {
            "session_token": new_user.session_token,
            "session_expiration": str(new_user.session_expiration),
            "update_token": new_user.update_token
        }, 201)


@app.route("/api/login/", methods=["POST"])
def login():
    body = json.loads(request.data)
    username=body.get("username")
    password=body.get("password")
    if not username:
        return failure_response("Username is required", 400)
    if not password:
        return failure_response("Password is required", 400)

    user = Users.query.filter_by(username=username).first()

    if user is None:
        return failure_response("user does not exist")

    if not user.verify_password(password):
        return failure_response("incorrect username or password", 401)
    
    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        })


@app.route("/api/session/")
def update_session(): 
    update_token = extract_token(request)
    if update_token is None:
        return failure_response("missing or invalid auth header", 401)
    user = Users.query.filter_by(update_token=update_token).first()
    if user is None:
        return failure_response(f"invalid update token: {update_token}", 401)
    user.renew_session()
    db.session.commit()

    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        })

def verify_session(session_token):
    if session_token is None:
        return False
    user_from_token = Users.query.filter_by(session_token=session_token).first()

    if user_from_token is None or not user_from_token.verify_session_token(session_token):
        return False
    return True
  
    
@app.route("/api/users/", methods=["DELETE"])
def delete_user():
    
    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("invalid token", 401)
    
    user = Users.query.filter_by(session_token=session_token).first()
    if user is None:
        return failure_response("User does not exist")
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

  

@app.route("/api/zipcode/", methods=["POST"])
def change_zipcode():
    
    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("invalid token", 401)
    
    user = Users.query.filter_by(session_token=session_token).first()
    if user is None:
        return failure_response("user does not exist")
    body = json.loads(request.data)
    zipcode = str(body.get("zipcode"))
    country_code = str(body.get("country_code", "US"))
    if Zipcodes.query.filter_by(number=zipcode).first() is None:
        new_zipcode=Zipcodes(number=zipcode, country_code=country_code)
        db.session.add(new_zipcode)
    zipcode_id = Zipcodes.query.filter_by(number=zipcode).first().id
    user.zipcode_id=zipcode_id
    db.session.commit()
    return success_response(user.serialize())

@app.route("/api/users/times/", methods=['POST'])
def add_times():
    
    session_token = extract_token(request)
    if not verify_session(session_token=session_token):
        return failure_response("invalid token", 401)

    user = Users.query.filter_by(session_token=session_token).first()
    body = json.loads(request.data)
    if user is None:
        return failure_response("user does not exist")
    times = body.get("time")
    if times is None:
        return failure_response("Must enter times to add!", 400)
    for time in times:
        if Times.query.filter_by(time=time).first() is None:
            new_time = Times(time=time)
            db.session.add(new_time)
        time1 = Times.query.filter_by(time=time).first()
        time1.users.append(user)
    db.session.commit()
    return success_response(user.serialize())


if __name__ == "__main__":
    port = os.environ.get("PORT", 5000)
    app.run(host="0.0.0.0", port=port) 