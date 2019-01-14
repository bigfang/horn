from factory.alchemy import SQLAlchemyModelFactory<%= unless bare do %>
from factory import PostGenerationMethodCall, Sequence<% end %>

from <%= app_name %>.core.database import db<%= unless bare do %>
from <%= app_name %>.models import User<% end %>



class BaseFactory(SQLAlchemyModelFactory):
    """Base factory."""

    class Meta:
        """Factory configuration."""
        abstract = True
        sqlalchemy_session = db.session

<%= unless bare do %>
class UserFactory(BaseFactory):
    username = Sequence(lambda n: f'user{n}')
    email = Sequence(lambda n: f'user{n}@example.com')
    password = PostGenerationMethodCall('set_password', 'example')

    class Meta:
        model = User
<% end %>
