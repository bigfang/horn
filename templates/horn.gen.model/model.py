from <%= model.app_name %>.core.database import db, Column, Model


class <%= model.alias %>(Model):
    __tablename__ = '<%= model.table %>'

    id = Column(db.Integer, primary_key=True)
    <%= for {k, v} <- model.types do %>
    <%= k %> = Column(db.<%= v %>, unique=False, nullable=False, doc='') <% end %>

    inserted_at = Column(db.DateTime, nullable=False,
                         server_default=db.func.now(), doc='插入时间')
    updated_at = Column(db.DateTime, nullable=False,
                        server_default=db.func.now(), onupdate=db.func.now(), doc='更新时间')
