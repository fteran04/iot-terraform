from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session

from db.database import get_session, init_db
from db import crud
from db.models import Tarea

from db.schemas import TaskResponse, TaskCrear, TaskActualizar

from publisher import publicar_tarea

import os

#lb
import socket

app = FastAPI()

@app.on_event("startup")
def startup():
    if os.getenv("INIT_DB") == "true":
        init_db()

def get_db():
    db = get_session()
    try:
        yield db
    finally:
        db.close()

### lb ###
@app.get("/debug")
def debug():
    return {"container": socket.gethostname()}

### ENDPOINTS ###

# GET - Obtener todos los usuarios
@app.get("/tareas", response_model=list[TaskResponse])
def obtener_tareas(db: Session = Depends(get_db)):
    return crud.listar_tareas(db)

# GET - Obtener una tarea por ID
@app.get("/tareas/{id}", response_model=TaskResponse)
def obtener_tarea(id: int, db: Session = Depends(get_db)):
    tarea = crud.obtener_tarea(db, id)
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    return tarea

# POST - Crear una nueva tarea
@app.post("/tareas", response_model=TaskResponse, status_code=201)
def crear_tarea(tarea: TaskCrear, db: Session = Depends(get_db)):
    tarea_db = crud.crear_tarea(db, estado=tarea.estado)
    publicar_tarea(tarea_db.id)
    return tarea_db

# PUT - Reemplazar una tarea completa
@app.put("/tareas/{id}", response_model=TaskResponse)
def reemplazar_tarea(id: int, tarea: TaskCrear, db: Session = Depends(get_db)):
    tarea_db = crud.reemplazar_tarea(db, id, tarea.estado)

    if not tarea_db:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    return tarea_db

# PATCH - Actualizar solo algunos campos
@app.patch("/tareas/{id}", response_model=TaskResponse)
def actualizar_tarea(id: int, datos: TaskActualizar, db: Session = Depends(get_db)):
    if datos.estado is None:
        raise HTTPException(status_code=400, detail="Nada para actualizar")

    tarea = crud.actualizar_estado(db, id, datos.estado)
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    
    return tarea

# DELETE - Eliminar una tarea
@app.delete("/tareas/{id}")
def eliminar_tarea(id: int, db: Session = Depends(get_db)):
    eliminado = crud.eliminar_tarea(db, id)
    if not eliminado:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    return {"mensaje": f"Tarea {id} eliminada correctamente"}