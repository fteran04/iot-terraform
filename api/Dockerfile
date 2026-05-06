# Imagen base de Python
FROM python:3.12-slim

# Instalar curl para healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copia e instala dependencias primero (mejor caché)
COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia tu código
COPY db ./db
COPY api/ .

# Puerto que expone el contenedor
EXPOSE 8000

# Comando para iniciar el servidor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]