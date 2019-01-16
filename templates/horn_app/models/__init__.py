<%= unless bare do %>
from .user import User


__all__ = [
    'User'
]
<% end %>
