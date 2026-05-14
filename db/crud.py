from sqlalchemy.orm import Session
from sqlalchemy import select
from db.models import Tarea


### CREATE ###
# Crea una nueva tarea.
# Parámetros:
# estado: cualquier string, por defecto 'pendiente'
# Ejemplo:
# tarea = crear_tarea(session)
# tarea = crear_tarea(session, estado="completada")
def crear_tarea(session: Session, estado: str = "pendiente") -> Tarea:
    tarea = Tarea(estado=estado)
    session.add(tarea)
    session.commit()
    session.refresh(tarea)
    print(f"Tarea creada -> id={tarea.id}, estado='{tarea.estado}'")
    return tarea


### READ ###
# Busca una tarea por su ID. Retorna None si no existe.
# Ejemplo:
# tarea = obtener_tarea(session, 1)
def obtener_tarea(session: Session, tarea_id: int) -> Tarea | None: 
    tarea = session.get(Tarea, tarea_id)
    if tarea is None:
        print(f"No existe ninguna tarea con id={tarea_id}")
    return tarea



def listar_tareas(session: Session, estado: str | None = None) -> list[Tarea]:
    stmt = select(Tarea)
    if estado:
        stmt = stmt.where(Tarea.estado == estado)
    stmt = stmt.order_by(Tarea.id)
    return list(session.scalars(stmt).all())


### UPDATE ###
# Cambia el estado de una tarea existente.
# Parámetros:
# tarea_id:     ID de la tarea a modificar
# nuevo_estado: cualquier string
# Ejemplo:
# tarea = actualizar_estado(session, 1, "completada")
def actualizar_estado(session: Session, tarea_id: int, nuevo_estado: str) -> Tarea | None:
    tarea = session.get(Tarea, tarea_id)
    if tarea is None:
        print(f"No existe ninguna tarea con id={tarea_id}")
        return None

    tarea.estado = nuevo_estado
    session.commit()
    session.refresh(tarea)
    print(f"Tarea id={tarea.id} actualizada -> estado='{tarea.estado}'")
    return tarea


### DELETE ###
# Elimina una tarea por su ID.
# Retorna True si fue eliminada, False si no existía.
# Ejemplo:
# eliminada = eliminar_tarea(session, 1)
def eliminar_tarea(session: Session, tarea_id: int) -> bool:
    tarea = session.get(Tarea, tarea_id)
    if tarea is None:
        print(f"No existe ninguna tarea con id={tarea_id}")
        return False

    session.delete(tarea)
    session.commit()
    print(f"Tarea id={tarea_id} eliminada.")
    return True