from <%= app_name %>.core.schema import ModelSchema, fields

from <%= app_name %>.models import User


class UserSchema(ModelSchema):
    username = fields.Str(required=True)
    email = fields.Email(required=True)
    password = fields.Str(required=True)

    class Meta:
        strict = True
        model = User
        fields = ('username', 'password', 'email', 'inserted_at', 'updated_at')
        load_only = ('password',)
        dump_only = ('inserted_at', 'updated_at')
