import json
from operator import ne
from db import db
from db import Courses
from db import Assignments
from db import Users
from flask import Flask
from flask import request

app = Flask(__name__)
db_filename = "final.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


# your routes here

#BELLA IS THE BEST CODER ABOVE MATEO

def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


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

@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    if not body.get("name"):
        return failure_response("User is missing a name", 400)
    if not body.get("netid"):
        return failure_response("User is missing a netid", 400)
    new_user = Users(name=body.get("name"),netid=body.get("netid"))
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

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
