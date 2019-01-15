from datetime import timedelta

from .default import *          # NOQA F401


ENV = 'development'
DEBUG = True
<%= unless bare do %>
JWT_ACCESS_TOKEN_EXPIRES = timedelta(10 ** 6)
<% end %>

SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:postgres@localhost/<%= app_name %>_dev'
