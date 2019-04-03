# Quickstart

After installed Horn, we can run `mix horn.new` to create our flask
application. In this tutorial, we create a simple application named `blog`:

```console
$ mix horn.new blog
* creating blog/Pipfile
* creating blog/README.md
* creating blog/pytest.ini
...
* creating blog/test/test_user.py
* creating blog/test/test_session.py

Fetch and install dependencies? [Yn]
```

Horn generates all files necessary for our project. then it will ask us if we want
install dependencies. we choose `[y]`

```console
Fetch and install dependencies? [Yn] y
* running pipenv install --dev
Creating a virtualenv for this project…
...
...
✔ Successfully created virtual environment!
...
Pipfile.lock not found, creating…
Locking [dev-packages] dependencies…
⠋ Locking..✔ Success!
Locking [packages] dependencies…
⠹ Locking..✔ Success!
Updated Pipfile.lock (5dbc0e)!
Installing dependencies from Pipfile.lock (5dbc0e)…
To activate this project's virtualenv, run pipenv shell.
Alternatively, run a command inside the virtualenv with pipenv run.

We are almost there! The following steps are missing:

    $ cd blog

Then configure your flask environment variables:

    $ export FLASK_ENV=development
    $ export FLASK_APP=app

And configure your database in app/config/development.py and run

    $ flask db init
    $ flask db migrate -m "init"
    $ flask db upgrade

Start your flask app with:

    $ pipenv run flask run
```

OK, let's try it. follow the steps above:

```console
...
...
$ pipenv shell
...
...
(blog) $ flask run 
 * Serving Flask app "app" (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 173-964-918
```

By default, flask application accept requests on port `5000`, we should open web
browser to access url [http://localhost:5000/api](http://localhost:5000/api), or
by using `curl http://localhost:5000/api` on console, then we will see the
welcome message:

```json
{"message": "Hello visitor, Welcome to Blog!"}
```

At last, Open your browser and visit
[http://localhost:5000/spec](http://localhost:5000/spec), all of our APIs are shown
in this page. We can browse and try them easily.


# Unit Testing

The application created by Horn contains sample unit tests. Let's run tests:

```console
(blog) $ pytest
...
collected 10 items

test/test_home.py::TestHome::test_home PASSED
test/test_session.py::TestSession::test_success_create PASSED
test/test_session.py::TestSession::test_failed_create PASSED
test/test_session.py::TestSession::test_delete PASSED
test/test_swagger.py::TestSwagger::test_swagger PASSED
test/test_user.py::TestUser::test_index PASSED
test/test_user.py::TestUser::test_create PASSED
test/test_user.py::TestUser::test_show PASSED
test/test_user.py::TestUser::test_update PASSED
test/test_user.py::TestUser::test_delete PASSED
...
...
```

Not bad, all tests passed! 


# Production Mode

To run application in production mode, try this:

```console
(blog) $ FLASK_ENV=production FLASK_APP=app flask run
```

We will see output similar to this:

```console
 * Serving Flask app "app"
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 ```

> `note` In production mode, Hron disabled swagger UI
