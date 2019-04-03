from flask import Blueprint, jsonify
from flask_jwt_extended import create_access_token

from <%= app_name %>.core import jwt_required, doc, use_kwargs, marshal_with
from <%= app_name %>.core.errors import <%= app_module %>Error
from <%= app_name %>.models import User
from <%= app_name %>.schemas import UserSchema


bp = Blueprint('session', __name__)


@doc(tags=['Session'], description='create session')
@bp.route('/sessions', methods=['POST'], provide_automatic_options=False)
@use_kwargs(UserSchema)
@marshal_with(UserSchema, code=201)
def create(username, password, email):
    user = User.query.filter_by(username=username).first()
    if user and user.check_password(password):
        user.token = create_access_token(identity=user, fresh=True)
        return user, 201
    else:
        raise <%= app_module %>Error.not_found(f'user {username} not found')


# TODO: implement it
@doc(tags=['Session'], description='delete session')
@bp.route('/sessions', methods=['DELETE'], provide_automatic_options=False)
@jwt_required
@marshal_with(None, code=204)   # FIXME
def delete():
    return True
