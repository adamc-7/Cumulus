from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# many users and many times
# many users and one zipcode

association_table = db.Table(
    "association",
    db.Model.metadata,
    db.Column("users", db.Integer, db.ForeignKey("users.id")),
    db.Column("times", db.DateTime, db.ForeignKey("courses.id")),
)


# your classes here

class Users(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    zipcode_id = db.Column(db.Integer, db.ForeignKey("zipcodes.id"), nullable=False)
    times = db.relationship("Times", secondary=association_table, back_populates="users")

    def __init__(self, **kwargs):
        self.username=kwargs.get("username")
        self.password=kwargs.get("password")
        self.zipcode=kwargs.get("zipcode")

    def subserialize(self):
        return{
            "id": self.id,
            "username": self.username,
            "zipcode": self.zipcode
        }
    
    def serialize(self):
        return{
            "id": self.id,
            "username": self.username,
            "zipcode": self.zipcode,
            "times": [t.subserialize() for t in self.times]
        }


class Times(db.Model):
    __tablename__ = "times"
    id = db.Column(db.Integer, primary_key=True)
    hour = db.Column(db.Integer, nullable = False)
    minute = db.Column(db.Integer, nullable = False)
    time = db.Column(db.DateTime) #or change to db.Column(db.Float)
    users = db.Relationship("Users", secondary=association_table, back_populates="times")


    def __init__(self, **kwargs):
        self.id = id
        self.hour=kwargs.get("hour")
        self.minute=kwargs.get("minute")

    def subserialize(self):
        return{
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date
        }
    
    def serialize(self):
        #course = Courses.query.filter_by(id=course_id).first()
        return{
            "id": self.id,
            "hour": self.hour,
            "minute": self.minute,
            #"course": [course.subserialize()]
        }


class Zipcodes(db.Model):
    __tablename__ = "zipcodes"
    id = db.Column(db.Integer, primary_key=True)
    number = db.Column(db.String, nullable=False)
    country_code = db.Column(db.String, nullable=False)
    users = db.relationship("Users")

    def __init__(self, **kwargs):
        self.netid=kwargs.get("number")

    def subserialize(self):
        return{
            "id": self.id,
            "name": self.name,
            "netid": self.netid
        }
    
    def serialize(self):
        courses = [t.subserialize() for t in self.student_courses]
        courses+=[t.subserialize() for t in self.instructor_courses]
        return{
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "courses": courses
        }

