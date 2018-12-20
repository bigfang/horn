from <%= app_name %>.views import home


def register_apispec(app):
    from apispec import APISpec
    from flask_apispec.extension import FlaskApiSpec

    app.config.update({
        'APISPEC_SPEC':
        APISpec(
            title='APP',
            version='v1',
            plugins=['apispec.ext.marshmallow'],
        ),
        'APISPEC_SWAGGER_URL': '/spec-json/',
        'APISPEC_SWAGGER_UI_URL': '/spec/'
    })

    spec = FlaskApiSpec(app)

    spec.register(home.home, blueprint='home')
