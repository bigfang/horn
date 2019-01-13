from flask import Blueprint
from flask_jwt_extended import jwt_required


from <%= app_name %>.core import doc, use_kwargs, marshal_with
from <%= app_name %>.schemas import UserSchema


bp = Blueprint('user', __name__)


@doc(tags=['User'], description='list users')
@bp.route('/users', methods=['GET'], provide_automatic_options=False)
@jwt_required
@marshal_with(UserSchema(many=True))
def index():
    pass


@doc(tags=['User'], description='create user')
@bp.route('/users', methods=['POST'], provide_automatic_options=False)
@jwt_required
@use_kwargs(UserSchema())
@marshal_with(UserSchema())
def create(username, email, password):
    pass


@doc(tags=['User'], description='show user')
@bp.route('/users/<int:pk>', methods=['GET'], provide_automatic_options=False)
@jwt_required
@marshal_with(UserSchema())
def show(pk):
    pass


@doc(tags=['User'], description='update user')
@bp.route('/users/<int:pk>', methods=['PUT'], provide_automatic_options=False)
@jwt_required
@use_kwargs(UserSchema())
@marshal_with(UserSchema())
def update(pk):
    pass


@doc(tags=['User'], description='delete user')
@bp.route('/users/<int:pk>', methods=['DELETE'], provide_automatic_options=False)
@jwt_required
def delete(pk):
    pass
