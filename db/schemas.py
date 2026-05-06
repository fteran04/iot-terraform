from pydantic import BaseModel

class TaskBase(BaseModel):
    estado: str

class TaskCrear(TaskBase):
    pass

class TaskActualizar(BaseModel):
    estado: str | None = None

class TaskResponse(TaskBase):
    id: int

    class Config:
        from_attributes = True