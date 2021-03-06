from <%= app_name %>.exts import ma as marshmallow
from marshmallow import (Schema, fields, pre_load, post_load, pre_dump,
                         post_dump)


# https://github.com/sloria/webargs/issues/126
# https://github.com/jmcarp/flask-apispec/issues/73
class ModelSchema(marshmallow.ModelSchema):
    @post_load()
    def make_instance(self, data):
        return data


__all__ = [
    'marshmallow',
    'ModelSchema',
    'Schema',
    'fields',
    'pre_load',
    'post_load',
    'pre_dump',
    'post_dump'
]
