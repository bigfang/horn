from <%= app_name %>.exts import ma
from marshmallow import (Schema, fields, pre_load, post_load, pre_dump,
                         post_dump)


# https://github.com/sloria/webargs/issues/126
# https://github.com/jmcarp/flask-apispec/issues/73
class ModelSchema(ma.ModelSchema):
    @post_load()
    def make_instance(self, data):
        return data


__all__ = [
    ma,
    ModelSchema,
    Schema,
    fields,
    pre_load,
    post_load,
    pre_dump,
    post_dump
]
