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

#MATEO IS THE BEST CODER ABOVE BELLA

def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

def extract_token(request):
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return None
    bearer_token = auth_header.replace("Bearer ", "").strip
    if bearer_token is None or not bearer_token:
        return  None
    return bearer_token




#gets weather for a specific user with a specific zipcode for the day
@app.route("/api/users/<int:user_id>/weather/daily/")
def get_daily_weather(api_key, user_id):
    user = Users.query.filter_by(id=user_id).first()
    zipcode_id = user.zipcode_id
    zipcode = Zipcodes.query.filter_by(id=zipcode_id).first()
    #body = json.loads(request.data)
    
    #if not body.get("country_code"):
    #    country_code = '001'
   # else:
       # country_code = body.get("country_code")


    url = f"http://api.openweathermap.org/data/2.5/weather?zip={zipcode.number},{zipcode.country_code}&appid={api_key}"

    response = requests.get(url).json()
    lon = response['coord']['lon']
    lat = response['coord']['lat']

    url1 = f"https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=currently,minutely,hourly,alerts&appid={api_key}"
    response1 = requests.get(url1).json()
    temp = response1['main']['temp']
    temp = math.floor((temp * 1.8) - 459.67)

    final_response = {}
    temp_morn = response1['daily']['temp']['morn']
    temp_morn = math.floor((temp_morn * 1.8) - 459.67)
    temp_day = response1['daily']['temp']['day']
    temp_day = math.floor((temp_day * 1.8) - 459.67)
    temp_eve = response1['daily']['temp']['eve']
    temp_eve = math.floor((temp_eve * 1.8) - 459.67)
    temp_night= response1['daily']['temp']['night']
    temp_night = math.floor((temp_night * 1.8) - 459.67)
    pop = response1['daily']['pop']
    if pop >= 0.8:
        rain_possible = "Very likely"
    elif pop >= 0.6:
        rain_possible = "Likely"
    elif pop >= 0.4:
        rain_possible = "Somewhat likely"
    elif pop >= 0.2:
        rain_possible = "Unlikely"
    elif pop >= 0:
        rain_possible = "Clear Day"
    if 'rain' in response1['daily']:
        rain_amount = response1['daily']['rain']
    else:
        rain_amount = None
    if 'snow' in response1['daily']:
        snow_amount = response1['daily']['snow']
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


@app.route("/api/users/<int:user_id>/weather/hourly")
def get_hourly_weather(api_key, user_id):
    user = Users.query.filter_by(id=user_id).first()
    zipcode_id = user.zipcode_id
    zipcode = Zipcodes.query.filter_by(id=zipcode_id).first()

    url = f"http://api.openweathermap.org/data/2.5/weather?zip={zipcode.number},{zipcode.country_code}&appid={api_key}"

    response = requests.get(url).json()
    lon = response['coord']['lon']
    lat = response['coord']['lat']

    url1 = f"https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=currently,minutely,daily,alerts&appid={api_key}"
    response1 = requests.get(url1).json()
    temp = response1['main']['temp']
    temp = math.floor((temp * 1.8) - 459.67) 

    pop = response1['hour']['pop']
    if pop >= 0.8:
        rain_possible = "Very likely"
    elif pop >= 0.6:
        rain_possible = "Likely"
    elif pop >= 0.4:
        rain_possible = "Somewhat likely"
    elif pop >= 0.2:
        rain_possible = "Unlikely"
    elif pop >= 0:
        rain_possible = "Clear Day"
    if 'rain' in response1['hour']:
        rain_amount = response1['hour']['rain']['1h']
    else:
        rain_amount = None
    if 'snow' in response1['hour']:
        snow_amount = response1['hour']['snow']['1h']
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
    return success_response(
        {"users": [t.serialize() for t in Users.query.all()]}
    )


#post contains username,password,zipcode
@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    username=body.get("username")
    password=body.get("password")
    zipcode=body.get("zipcode")
    times = body.get("times", [])
    if not username:
        return failure_response("Username is required", 400)
    if not password:
        return failure_response("Password is required", 400)
    if not zipcode:
        return failure_response("Zipcode is required", 400)
    if Zipcodes.query.filter(Zipcodes.number==zipcode).first() is None:
        new_zipcode=Zipcodes(number=zipcode)
        db.session.add(new_zipcode)
        db.session.commit()
    if Users.query.filter(Users.username==username).first() is not None:
        return failure_response("user already exists")
    zipcode_id=Zipcodes.query.filter(Zipcodes.number==zipcode).first().id
    new_user = Users(username=username, password=password, zipcode_id=zipcode_id, times=times)
    db.session.add(new_user)
    db.session.commit()

    return success_response(
        {
            "session_token": new_user.session_token,
            "session_expiration": str(new_user.session_expiration),
            "update_token": new_user.update_token
        }, 201)
    #return success_response(new_user.serialize(), 201)


@app.route("/api/login/", methods=["POST"])
def login():
    body = json.loads(request.data)
    username=body.get("username")
    password=body.get("password")
    if not username:
        return failure_response("Username is required", 400)
    if not password:
        return failure_response("Password is required", 400)

    user = Users.query.filter(Users.username==username).first()

    if user is None:
        return failure_response("user does not exist")

    if not user.verify_password(password):
        return failure_response("incorrect username or password")
    
    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }, 201)


@app.route("/api/session/", methods=["POST"])
def update_session(): 
    update_token = extract_token(request)

    if update_token is None:
        return failure_response("missing or invalid auth header")

    user = Users.query.filter(Users.update_token==update_token).first()

    if user is None:
        return failure_response(f"invalid update token: {update_token}")

    user.renew_session()
    db.session.commit()

    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }, 201)


@app.route("/api/session/", methods=["GET"])
def verify_session(): 
    session_token = extract_token(request)

    if session_token is None:
        return failure_response("missing or invalid auth header")

    user = Users.query.filter(Users.session_token==session_token).first()

    if user is None or not user.verify_session_token(session_token):
        return failure_response("invalid session token")
    return success_response("session is active")
  
    
@app.route("/api/users/<int:user_id>/", methods=["DELETE"])
def delete_user(user_id):
    user = Users.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User does not exist")
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

  

@app.route("/api/users/<int:user_id>/zipcode/", methods=["POST"])
def change_zipcode(user_id):
    user = Users.query.filter_by(id=user_id).first()
    body = json.loads(request.data)
    if user is None:
        return failure_response("user does not exist")
    zipcode = body.get("zipcode")
    if Zipcodes.query.filter(Zipcodes.number==zipcode).first() is None:
        new_zipcode=Zipcodes(number=zipcode)
        db.session.add(new_zipcode)
    user.zipcode=zipcode
    db.session.commit()
    return success_response(user.serialize())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)