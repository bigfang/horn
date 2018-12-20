from flask import url_for


class TestPortalViews(object):

    def test_home(self, testapp):
        resp = testapp.get(url_for('home.home'))
        assert resp.status_code == 200
        assert 'Welcome to Horn!' in resp.json['message']
