import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from db.models import Base

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg2://mi_usuario:mi_password@db:5432/tareas_db"
)

engine = create_engine(DATABASE_URL, echo=False)

SessionLocal = sessionmaker(bind=engine)


def init_db():
    """Crea la tabla 'tareas' si no existe."""
    Base.metadata.create_all(engine)
    print("Base de datos inicializada.")


def get_session() -> Session:
    """Retorna una sesión lista para usar."""
    return SessionLocal()