from <%= app_name %>.exts import db


# From Mike Bayer's "Building the app" talk
# https://speakerdeck.com/zzzeek/building-the-app
class SurrogatePK(object):
    __table_args__ = {'extend_existing': True}

    id = db.Column(db.Integer, primary_key=True)
    inserted_at = db.Column(db.DateTime, nullable=False, index=True,
                            server_default=db.func.now())
    updated_at = db.Column(db.DateTime, nullable=False, index=True,
                           server_default=db.func.now(), onupdate=db.func.now())

    def __repr__(self):
        return '<{classname}({pk})>'.format(
            classname=type(self).__name__, pk=self.id)
