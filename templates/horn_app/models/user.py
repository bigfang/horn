from <%= app_name %>.core.database import db, Column, Model
from <%= app_name %>.exts import bcrypt


class User(Model):
    __tablename__ = 'users'

    id = Column(db.Integer, primary_key=True)
    username = Column(db.String(), unique=True, nullable=False)
    email = Column(db.String(), unique=True, nullable=False)
    password = Column(db.Binary(128), nullable=True)
    inserted_at = Column(db.DateTime, nullable=False, index=True,
                         server_default=db.func.now())
    updated_at = Column(db.DateTime, nullable=False, index=True,
                        server_default=db.func.now(), onupdate=db.func.now())


    def __init__(self, username, email, password=None, **kwargs):
        Model.__init__(self, username=username, email=email, **kwargs)
        if password:
            self.set_password(password)
        else:
            self.password = None

    def set_password(self, password):
        self.password = bcrypt.generate_password_hash(password)

    def check_password(self, value):
        return bcrypt.check_password_hash(self.password, value)

    def __repr__(self):
        return f'<User({self.username!r})>'
