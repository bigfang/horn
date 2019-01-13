from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow<%= unless bare do %>
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager <% end %>

<%= unless bare do %>
bcrypt = Bcrypt()<% end %>
db = SQLAlchemy()
migrate = Migrate()
ma = Marshmallow()

<%= unless bare do %>
from <%= app_name %>.helpers import jwt_identity, identity_loader  # noqa

jwt = JWTManager()
jwt.user_loader_callback_loader(jwt_identity)
jwt.user_identity_loader(identity_loader) <% end %>
