import pika
import json

def publicar_tarea(tarea_id: int):
    credentials = pika.PlainCredentials("admin", "admin")

    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host="rabbitmq",
            credentials=credentials
        )
    )

    channel = connection.channel()

    channel.queue_declare(queue='tareas')

    mensaje = {"id": tarea_id}

    channel.basic_publish(
        exchange='',
        routing_key='tareas',
        body=json.dumps(mensaje)
    )

    print(f"Enviado a Rabbit: {mensaje}")

    connection.close()