import requests
import time

BASE_URL = "http://lb"

def esperar_api():
    print("Esperando a que la API esté disponible...")
    while True:
        try:
            r = requests.get(f"{BASE_URL}/tareas")
            if r.status_code == 200:
                print("API lista")
                break
        except requests.exceptions.ConnectionError:
            pass
        
        time.sleep(2)

esperar_api()

# # GET - Obtener todos
# respuesta = requests.get(f"{BASE_URL}/tareas")
# print(respuesta.json())

# # GET - Obtener uno
# respuesta = requests.get(f"{BASE_URL}/tareas/1")
# print(respuesta.json())

# # POST - Crear
# nuevo = {"estado": "pendiente"}
# respuesta = requests.post(f"{BASE_URL}/tareas", json=nuevo)
# print(respuesta.status_code)
# print(respuesta.json())

# # PUT - Reemplazar completo
# actualizado = {"estado": "completada"}
# respuesta = requests.put(f"{BASE_URL}/tareas/3", json=actualizado)
# print(respuesta.json())

# # PATCH - Actualizar parcial
# respuesta = requests.patch(f"{BASE_URL}/tareas/3", json={"estado": "pendiente"})
# print(respuesta.json())

# # DELETE - Eliminar
# respuesta = requests.delete(f"{BASE_URL}/tareas/3")
# print(respuesta.json())

# ── LOOP INFINITO ─────────────────────────────────────
print("\n=== Iniciando loop, creando una tarea cada 5 segundos ===")
while True:
    nueva_tarea = {"estado": "pendiente"}
    respuesta = requests.post(f"{BASE_URL}/tareas", json=nueva_tarea)
    print(f"Tarea creada → {respuesta.json()}")
    time.sleep(5)