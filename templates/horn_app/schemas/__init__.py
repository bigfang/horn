<%= unless bare do %>
from .user import UserSchema


__all__ = [
    UserSchema
]
<% end %>
