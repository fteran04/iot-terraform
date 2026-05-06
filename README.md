# interfaz
http://localhost:8000/docs

# Construir 
docker compose up -d --build

# Entrar
docker exec -it api_db_worker_project-producer-1 bash

# CURL
curl http://localhost:8000/tareas           # GET (descarga datos)

curl -X POST http://localhost:8000/tareas \
  -H "Content-Type: application/json" \
  -d '{"estado": "pendiente"}'   # POST (envía datos)


# Mirar logs
docker compose logs -f api

# Debud del load balancer
curl http://localhost:8000/debug
