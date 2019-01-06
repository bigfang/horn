import logging.config

from flask import Flask
from flask.helpers import get_env

from <%= app_name %> import cmds
from <%= app_name %>.exts import db, migrate, ma, bcrypt
from <%= app_name %>.router import register_blueprints
from <%= app_name %>.core.errors import InvalidUsage


def register_extensions(app):
    bcrypt.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)
    ma.init_app(app)


def register_shellcontext(app):
    def shell_context():
        return {
            'db': db,
        }
    app.shell_context_processor(shell_context)


def register_commands(app):
    app.cli.add_command(cmds.clean)
    app.cli.add_command(cmds.test)
    app.cli.add_command(cmds.lint)


def register_errorhandlers(app):
    def errorhandler(error):
        response = error.to_json()
        response.status_code = error.status_code
        return response
    app.errorhandler(InvalidUsage)(errorhandler)


def register_logging(app):
    logging.config.fileConfig(
        app.config.get('LOG_CONF_PATH'),
        defaults={"logdir": app.config.get('LOG_PATH')})


def create_app(config=None):
    conf_map = {
        'dev': 'development',
        'prod': 'production',
        'test': 'testing'
    }
    config_obj = conf_map.get(config) or get_env()

    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(f'<%= app_name %>.configs.{config_obj}')
    app.url_map.strict_slashes = False

    register_extensions(app)
    register_blueprints(app)
    register_errorhandlers(app)
    register_shellcontext(app)
    register_commands(app)

    if config_obj != 'testing':
        register_logging(app)

    if config_obj == 'production':
        app.config.from_pyfile('prod.secret.cfg', silent=True)
    elif config_obj == 'development':
        from app_name.swagger import register_apispec
        register_apispec(app)

    return app


app = create_app()
