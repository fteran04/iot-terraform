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

# Crea la tabla 'tareas' si no existe
def init_db():
    
    Base.metadata.create_all(engine)
    print("Base de datos inicializada.")

# Retorna una sesión lista para usar
def get_session() -> Session:
    return SessionLocal()