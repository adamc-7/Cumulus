from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()



association_table_time = db.Table(
    "association_time",
    db.Model.metadata,
    db.Column("time", db.Integer, db.ForeignKey("courses.id")),
    db.Column("calendar", db.Integer, db.ForeignKey("users.id")),
    db.Column("weather", db.Integer, db.ForeignKey("users.id"))
)
    
association_table_outside = db.Table(
    "association_outside",
    db.Model.metadata,
    db.Column("time_outside", db.Integer, db.ForeignKey("time_outside.id")),
    db.Column("weather", db.Integer, db.ForeignKey("weather.id"))
)
    

# your classes here

class Days(db.Model):
    __tablename__ = "days"
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    times_outside = db.relationship("Assignments", secondary=association_table_time, cascade="delete")

    def __init__(self, **kwargs):
        self.code=kwargs.get("code")
        self.name=kwargs.get("name")

    def subserialize(self):
        return{
            "id": self.id,
            "code": self.code,
            "name": self.name
        }
    
    def serialize(self):
        return{
            "id": self.id,
            "code": self.code,
            "name": self.name,
            "assignments": [t.subserialize() for t in self.assignments],
            "instructors": [t.subserialize() for t in self.instructors],
            "students": [t.subserialize() for t in self.students]
        }


class Times_outside(db.Model):
    __tablename__ = "times_outside"
    id = db.Column(db.Integer, primary_key=True)
    times_outside = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.title=kwargs.get("title")
        self.due_date=kwargs.get("due_date")
        self.course_id=kwargs.get("courses")

    def subserialize(self):
        return{
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date
        }
    
    def serialize(self):
        course = Courses.query.filter_by(id=self.course_id).first()
        return{
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date,
            "course": [course.subserialize()]
        }


class Users(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    instructor_courses = db.relationship("Courses", secondary=association_table_instructor, back_populates="instructors")
    student_courses= db.relationship("Courses", secondary=association_table_user, back_populates="students")

    def __init__(self, **kwargs):
        self.netid=kwargs.get("netid")
        self.name=kwargs.get("name")

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

