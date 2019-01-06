from flask import jsonify


def template(msg, code=500):
    return {
        'message': msg,
        'status_code': code
    }


class InvalidUsage(Exception):
    status_code = 500

    def __init__(self, message, status_code=None, payload=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_json(self):
        rv = self.message
        return jsonify(rv)

    @classmethod
    def custom_error(cls, obj='未知错误', code=500):
        msg = template(obj, code=code)
        return cls(**msg)

    @classmethod
    def already_exists(cls, obj='sth.'):
        msg = template(
            '{} 已存在'.format(obj), code=422)
        return cls(**msg)

    @classmethod
    def not_found(cls, obj='sth.'):
        msg = template('{} 不存在'.format(obj), code=404)
        return cls(**msg)

    @classmethod
    def invalid_passwd(cls):
        msg = template('无效的密码', code=400)
        return cls(**msg)

    @classmethod
    def update_failed(cls, obj='sth.'):
        msg = template(
            '{} 更新失败'.format(obj), code=400)
        return cls(**msg)

    @classmethod
    def delete_failed(cls, obj='sth.'):
        msg = template(
            '{} 删除失败'.format(obj), code=400)
        return cls(**msg)
