from <%= app_name %>.core.schema import ModelSchema, fields

from <%= app_name %>.models import User

from .helpers import SchemaMixin


class UserSchema(ModelSchema, SchemaMixin):
    username = fields.Str(required=True)
    password = fields.Str(required=True)
    email = fields.Email(missing=None)
    token = fields.Str()

    class Meta:
        strict = True
        model = User
        fields = ('username', 'password', 'email', 'token', 'inserted_at',
                  'updated_at')
        load_only = ('password',)
        dump_only = ('inserted_at', 'updated_at', 'token')
