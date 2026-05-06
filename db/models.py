from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    pass

class Tarea(Base):
    __tablename__ = "tareas"

    id     = Column(Integer, primary_key=True, autoincrement=True)
    estado = Column(String(20), nullable=False, default="pendiente")

    def __repr__(self):
        return f"<Tarea(id={self.id}, estado='{self.estado}')>"