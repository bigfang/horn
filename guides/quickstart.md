# Quickstart

After installed horn, we can run `mix horn.new` to create our flask
application. In this tutorial, we create a simple application named `blog`:

```console
$ mix horn.new blog
* creating blog/Pipfile
* creating blog/README.md
* creating blog/pytest.ini
...
* creating blog/test/test_swagger.py
* creating blog/test/test_home.py

Fetch and install dependencies? [Yn]
```

Horn generates all files necessary for our project. then it will ask us if we want
install dependencies. we choose `[y]`

```console
Fetch and install dependencies? [Yn] y
* running pipenv install --dev
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

Start your flask app with:

    $ pipenv shell
    $ FLASK_APP=app.run flask run
```

OK, let's try it. follow the steps above:

```console
$ pipenv shell
...
...
(blog) $ FLASK_APP=app.run flask run 
 * Serving Flask app "app.run"
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
```

By default, flask application accept requests on port `5000`, we should open web
browser to access url [http://localhost:5000/api](http://localhost:5000/api), or
by using `curl http://localhost:5000/api` on console, then we will see the
welcome message:

```json
{"message": "Hello visitor, Welcome to Blog!"}
```


# Unit Testing

The application created by Horn contains sample unit tests. Let's run tests:

```console
(blog) $ pytest
...
collected 2 items

test/test_home.py::TestPortalViews::test_home PASSED
test/test_swagger.py::TestSwagger::test_swagger PASSED
...
...
```

Not bad, all tests passed! 


# Development Mode

To run application in development mode, try this:

```console
(blog) $ FLASK_ENV=development FLASK_APP=app.run flask run
```

We will see output similar to this:

```console
 * Serving Flask app "app.run" (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 123-456-789
```

In development mode, Hron project adds a new router to show api specifications,
we can visit url [http://localhost:5000/spec](http://localhost:5000/spec) to
access it.
