import traceback

from flask import current_app, jsonify


ERR_CODE_MAP = {
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    409: 'Conflict',

    500: 'Internal Server Error'
}


def make_err_resp(error):
    response = error.to_json()
    response.status_code = error.status_code
    return response


def template(msg=None, code=None, detail=None, status=500):

    code = code or status
    msg = msg or ERR_CODE_MAP.get(code)

    assert isinstance(status, int)
    assert isinstance(code, int)
    assert isinstance(msg, str)
    assert isinstance(detail, str)

    message = {
        'message': msg,
        'code': code,
        'detail': detail
    }
    if current_app.env != 'production':
        message.update({'traceback': traceback.format_exc()})

    return {
        'message': message,
        'status_code': status
    }


class <%= app_module %>Error(Exception):
    status_code = 500

    def __init__(self, message, status_code=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code

    def to_json(self):
        rv = self.message
        return jsonify(rv)

    @classmethod
    def custom(cls, err=None, msg=None, code=None, status=500):
        detail = None
        if isinstance(err, Exception):
            detail = repr(err)
        elif isinstance(err, str):
            detail = err
        tpl = template(msg=msg, code=code, detail=detail, status=status)
        return cls(**tpl)

    @classmethod
    def bad_request(cls, err, code=None):
        return cls.custom(err=err, code=code, status=400)

    @classmethod
    def unauthorized(cls, err, code=None):
        return cls.custom(err=err, code=code, status=401)

    @classmethod
    def forbidden(cls, err, code=None):
        return cls.custom(err=err, code=code, status=403)

    @classmethod
    def not_found(cls, err, code=None):
        return cls.custom(err=err, code=code, status=404)

    @classmethod
    def conflict(cls, err, code=None):
        return cls.custom(err=err, code=code, status=409)


class ErrorHandler(object):
    @classmethod
    def handler_others(cls, exc):
        return <%= app_module %>Error.custom(err=exc)

    @classmethod
    def handler_werkzeug_exceptions(cls, exc):
        return <%= app_module %>Error.custom(err=exc.description, msg=exc.name, code=exc.code, status=exc.code)

    @classmethod
    def handler_sqlalchemy_orm_exc(cls, exc):
        if exc.__class__.__name__ == 'NoResultFound':
            return <%= app_module %>Error.not_found(exc)
        return <%= app_module %>Error.custom(err=exc, code=exc.code)

    @classmethod
    def handler(cls, err):
        if isinstance(err, <%= app_module %>Error):
            return make_err_resp(err)

        exc = 'others'
        if hasattr(err, '__module__'):
            exc = err.__module__.replace('.', '_')
        error = getattr(cls, 'handler_{}'.format(exc), cls.handler_others)(err)
        return make_err_resp(error)
