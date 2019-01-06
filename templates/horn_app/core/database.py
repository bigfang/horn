from sqlalchemy.orm import relationship

from <%= app_name %>.exts import db


# Alias common SQLAlchemy names
Column = db.Column


class CRUDMixin(object):
    """Mixin that adds convenience methods for CRUD (create, read, update, delete) operations."""

    @classmethod
    def create(cls, **kwargs):
        """Create a new record and save it the database."""
        instance = cls(**kwargs)
        return instance.save()

    def update(self, commit=True, **kwargs):
        """Update specific fields of a record."""
        for attr, value in kwargs.items():
            setattr(self, attr, value)
        return commit and self.save() or self

    def save(self, commit=True):
        """Save the record."""
        db.session.add(self)
        if commit:
            db.session.commit()
        return self

    def delete(self, commit=True):
        """Remove the record from the database."""
        db.session.delete(self)
        return commit and db.session.commit()

    @classmethod
    def exist(cls, id):
        rcd = cls.query.get(id)
        return True and rcd

    @classmethod
    def upsert(cls, constraint, **kwargs):
        q = cls.query
        rcd = None
        if isinstance(constraint, str):
            rcd = cls.query.filter(
                getattr(cls, constraint) == kwargs.get(constraint)).first()
        elif isinstance(constraint, list) or isinstance(constraint, tuple):
            for c in constraint:
                q = q.filter(getattr(cls, c) == kwargs.get(c))
            rcd = q.first()

        if not rcd:
            instance = cls(**kwargs)
            return instance.save()
        else:
            for k, v in kwargs.items():
                setattr(rcd, k, v)
            return rcd.save()

    @classmethod
    def insert_many(cls, rcds, commit=True):
        assert isinstance(rcds, list)
        db.session.add_all(rcds)
        if commit:
            db.session.commit()
        return True

    @classmethod
    def delete_many(cls, rcds, commit=True):
        assert isinstance(rcds, list)
        for rcd in rcds:
            db.session.delete(rcd)
        if commit:
            db.session.commit()
        return True

    @classmethod
    def update_many(cls, rcds, commit=True):
        assert isinstance(rcds, list)
        for rcd in rcds:
            db.session.add(rcd)
        if commit:
            db.session.commit()
        return True

    def flush(self):
        db.session.flush()


class Model(CRUDMixin, db.Model):
    """Base model class that includes CRUD convenience methods."""
    __abstract__ = True


def reference_col(tablename, nullable=False, pk_name='id', **kwargs):
    """Column that adds primary key foreign key reference.

    Usage: ::

        category_id = reference_col('category')
        category = relationship('Category', backref='categories')
    """
    return db.Column(db.ForeignKey('{0}.{1}'.format(tablename, pk_name)),
                     nullable=nullable, **kwargs)


__all__ = [
    db,
    Model,
    Column,
    relationship,
    reference_col
]
