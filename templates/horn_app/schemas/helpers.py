from marshmallow import fields


class SchemaMixin(object):
    id = fields.Int(dump_only=True)
    inserted_at = fields.DateTime('%Y-%m-%d %H:%M:%S', dump_only=True)
    updated_at = fields.DateTime('%Y-%m-%d %H:%M:%S', dump_only=True)

    class Meta:
        dump_only = ('id', 'inserted_at', 'updated_at')
        strict = True
        ordered = False
        dateformat = '%Y-%m-%d %H:%M:%S'
