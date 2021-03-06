from <%= app_name %>.core.schema import fields, Schema


class EmptySchema(Schema):
    pass


class SchemaMixin(object):
    id = fields.Int(dump_only=True)
    inserted_at = fields.DateTime('%Y-%m-%d %H:%M:%S', dump_only=True)
    updated_at = fields.DateTime('%Y-%m-%d %H:%M:%S', dump_only=True)

    class Meta:
        strict = True
        ordered = False
        dateformat = '%Y-%m-%d %H:%M:%S'
