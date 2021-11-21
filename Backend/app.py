import json
from operator import ne
from db import db
from db import Courses
from db import Assignments
from db import Users
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

#BELLA IS THE BEST CODER ABOVE MATEO

def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code



#gets weather for a specific user with a specific zipcode for the day
@app.route("/api/users/<int:user_id>/weather/", methods=["POST"])
def get_weather(api_key, user_id):
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

    url1 = f"https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude={currently, minutely, hourly, alerts}&appid={api_key}"
    temp = math.floor((temp * 1.8) - 459.67)
    response1 = requests.get(url1).json()

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
    snow_amount = response1['daily']['snow']
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



@app.route("/api/users/<int:user_id>/weather/", methods=["POST"])

@app.route("/api/courses/")
def get_courses():
    return success_response(
        {"courses": [t.serialize() for t in Courses.query.all()]}
    )

@app.route("/api/courses/", methods=["POST"])
def create_course():
    body = json.loads(request.data)
    if not body.get("code"):
        return failure_response("Course is missing a code", 400)
    if not body.get("name"):
        return failure_response("Course is missing a name", 400)
    new_course = Courses(code=body.get("code"), name=body.get("name"))
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)

@app.route("/api/courses/<int:course_id>/")
def get_course(course_id):
    course = Courses.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course does not exist")
    return success_response(course.serialize())    
    
@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    course = Courses.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course does not exist")
    db.session.delete(course)
    db.session.commit()
    return success_response(course.serialize())

#created new user
@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    if not body.get("username"):
        return failure_response("User is missing a username", 400)
    if not body.get("password"):
        return failure_response("User is missing a password", 400)
    if not body.get("zipcode"):
        return failure_response("User is missing a zipcode", 400)
    if not body.get("times"):
        times = []
    else:
        times = body.get("times")
    new_user = Users(username=body.get("username"),password=body.get("password"), zipcode=body.get("zipcode"), times=times)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

#completed delete method
@app.route("api/users/<int:user_id>/", methods = ['DELETE'])
def delete_user(user_id);
    user = Courses.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User does not exist")
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    user = Users.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User does not exist")
    return success_response(user.serialize())  

@app.route("/api/courses/<int:course_id>/add/", methods=["POST"])
def add_user_to_course(course_id):
    course = Courses.query.filter_by(id=course_id).first()
    body = json.loads(request.data)
    if course is None:
        return failure_response("Course does not exist")
    user_id = body.get("user_id")
    user = Users.query.filter_by(id=user_id).first()
    if (body.get("type") == "instructor"):
        course.instructors = [user]
    else:
        course.students = [user]
    db.session.commit()
    return success_response(course.serialize())

@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def create_assignment(course_id):
    course = Courses.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course does not exist")
    body = json.loads(request.data)
    if not body.get("title"):
        return failure_response("Assignment is missing a title", 400)
    if not body.get("due_date"):
        return failure_response("Assignment is missing a due date", 400)
    new_assignment = Assignments(title=body.get("title"), due_date=body.get("due_date"), courses=course_id)
    db.session.add(new_assignment)
    db.session.commit()
    return success_response(new_assignment.serialize(), 201)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
