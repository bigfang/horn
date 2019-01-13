from <%= app_name %>.models import User  # noqa


def jwt_identity(payload):
    return User.query.get(payload)


def identity_loader(user):
    return user.id
