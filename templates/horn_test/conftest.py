from flask import url_for

import pytest
from webtest import TestApp

from <%= app_name %>.run import create_app
from <%= app_name %>.core.database import db as _db
<%= unless bare do  %>
from .factories import UserFactory
<% end %>


@pytest.fixture(scope='session')
def app():
    _app = create_app('test')

    with _app.app_context():
        _db.create_all()

    ctx = _app.test_request_context()
    ctx.push()

    yield _app

    ctx.pop()


@pytest.fixture(scope='session')
def testapp(app):
    return TestApp(app)


@pytest.fixture(scope='module')
def testdb(app):
    _db.app = app
    with app.app_context():
        _db.create_all()

    yield _db

    # Explicitly close DB connection
    _db.session.close()
    _db.drop_all()


<%= unless bare do  %>
@pytest.fixture
def user(testdb):
    user = UserFactory(password='wordpass')
    user.save()
    return user


@pytest.fixture
def login_user(testdb, testapp):
    user = UserFactory(password='iamloggedin')
    user.save()
    testapp.post_json(url_for('session.create'), {
        'username': user.username,
        'password': 'iamloggedin'
    })
    testapp.authorization = ('Bearer', user.token)

    return user
<% end %>
