from flask import Blueprint
from flask_jwt_extended import jwt_required

from <%= app_name %>.core import doc, use_kwargs, marshal_with
from <%= app_name %>.schemas import UserSchema


bp = Blueprint('session', __name__)


@doc(tags=['Session'], description='create session')
@bp.route('/sessions', methods=['POST'], provide_automatic_options=False)
@use_kwargs(UserSchema())
@marshal_with(UserSchema())
def create():
    pass


# TODO: implement it
@doc(tags=['Session'], description='delete session')
@bp.route('/sessions', methods=['DELETE'], provide_automatic_options=False)
@jwt_required
@use_kwargs(UserSchema())
@marshal_with(UserSchema())
def delete():
    return 204
