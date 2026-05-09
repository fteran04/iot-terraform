# Imagen base de Python liviana
FROM python:3.12-slim

RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*


# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copia e instala dependencias primero
COPY producer/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código
COPY producer/producer.py .

# Comando para correr el producer
CMD ["python", "producer.py"]
# CMD ["tail", "-f", "/dev/null"]