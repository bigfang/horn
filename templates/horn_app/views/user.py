from flask import Blueprint
from flask_jwt_extended import jwt_required

from sqlalchemy.exc import IntegrityError

from <%= app_name %>.core import doc, use_kwargs, marshal_with
from <%= app_name %>.core.database import db, atomic
from <%= app_name %>.models import User
from <%= app_name %>.schemas import UserSchema


bp = Blueprint('user', __name__)


@doc(tags=['User'], description='list users')
@bp.route('/users', methods=['GET'], provide_automatic_options=False)
@jwt_required
@marshal_with(UserSchema(many=True), code=200)
def index():
    users = User.query.all()
    return users


@doc(tags=['User'], description='create user')
@bp.route('/users', methods=['POST'], provide_automatic_options=False)
@use_kwargs(UserSchema)
@marshal_with(UserSchema, code=201)
def create(username, email, password):
    user = User.create(username=username, email=email, password=password)
    return user, 201


@doc(tags=['User'], description='show user')
@bp.route('/users/<int:pk>', methods=['GET'], provide_automatic_options=False)
@jwt_required
@marshal_with(UserSchema, code=200)
def show(pk):
    user = User.query.get_or_404(pk)
    return user


# TODO: implement it
@doc(tags=['User'], description='update user')
@bp.route('/users/<int:pk>', methods=['PUT'], provide_automatic_options=False)
@jwt_required
@use_kwargs(UserSchema)
@marshal_with(UserSchema, code=200)
def update(pk):
    pass


@doc(tags=['User'], description='delete user')
@bp.route('/users/<int:pk>', methods=['DELETE'], provide_automatic_options=False)
@jwt_required
@marshal_with(None, code=204)   # FIXME
@atomic(db.session)
def delete(pk):
    user = User.query.get_or_404(pk)
    try:
        user.delete(commit=False)
    except IntegrityError as e:
        raise e
    return True
