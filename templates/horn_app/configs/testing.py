from .default import *          # NOQA F401


ENV = 'development'
TESTING = True
<%= unless bare do %>
BCRYPT_LOG_ROUNDS = 4
<% end %>
SQLALCHEMY_DATABASE_URI = 'sqlite://'
