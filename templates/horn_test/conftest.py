import pytest
from webtest import TestApp

from <%= app_name %>.run import create_app
from <%= app_name %>.core.database import db as _db


@pytest.fixture(scope='session')
def app():
    """An application for the tests."""
    _app = create_app('test')

    with _app.app_context():
        _db.create_all()

    ctx = _app.test_request_context()
    ctx.push()

    yield _app

    ctx.pop()


@pytest.fixture(scope='session')
def testapp(app):
    """A Webtest app."""
    return TestApp(app)


@pytest.fixture(scope='module')
def testdb(app):
    """A database for the tests."""
    _db.app = app
    with app.app_context():
        _db.create_all()

    yield _db

    # Explicitly close DB connection
    _db.session.close()
    _db.drop_all()
