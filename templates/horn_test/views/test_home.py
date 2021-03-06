from flask import url_for


class TestHome(object):

    def test_home(self, testapp):
        resp = testapp.get(url_for('home.home'))
        assert resp.status_code == 200
        assert 'Hello visitor,' in resp.json['message']
