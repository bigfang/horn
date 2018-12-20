from flask import Blueprint, jsonify

from <%= app_name %>.core import doc


bp = Blueprint('home', __name__)


@doc(tags=['home'], description='home',
     responses={'200': {
         'description': 'success',
         'schema': {
             'type': 'object',
             'properties': {
                 'message': {'type': 'string'}
             }
         }
     }})
@bp.route('/', methods=('GET', ))
def home():
    return jsonify({
        'message': 'Hello <%= app_module %>! Welcome to Horn!'
    })
