import os


PROJ_ROOT = os.path.split(os.path.abspath(__name__))[0]
LOG_CONF_PATH = os.path.join(PROJ_ROOT, 'logging.ini')
LOG_PATH = os.path.join(PROJ_ROOT, 'log')

SECRET_KEY = '<%= secret_key_base %>'
<%= unless bare do %>
BCRYPT_LOG_ROUNDS = 13
<% end %>

SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:postgres@localhost/<%= app_name %>'
SQLALCHEMY_TRACK_MODIFICATIONS = False
