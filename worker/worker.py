import pika
import json
import time
from db.database import get_session
from db import crud

def callback(ch, method, properties, body):
    data = json.loads(body)
    tarea_id = data["id"]

    print(f"Recibido: {tarea_id}")

    db = get_session()

    time.sleep(5)

    tarea = crud.actualizar_estado(db, tarea_id, "en ejecucion")

    time.sleep(5)

    tarea = crud.actualizar_estado(db, tarea_id, "completada")

    if tarea:
        print(f"Tarea {tarea_id} completada")
    else:
        print(f"No encontrada {tarea_id}")

    db.close()

    ch.basic_ack(delivery_tag=method.delivery_tag)


def conectar_rabbit():
    while True:
        try:
            credentials = pika.PlainCredentials("admin", "admin")

            connection = pika.BlockingConnection(
                pika.ConnectionParameters(
                    host=os.getenv("RABBITMQ_HOST", "rabbitmq"),
                    credentials=credentials
                )
            )

            print("Conectado a Rabbit")
            return connection

        except Exception as e:
            print("Esperando Rabbit...", e)
            time.sleep(3)


def main():
    connection = conectar_rabbit()
    channel = connection.channel()

    channel.queue_declare(queue='tareas')

    channel.basic_consume(
        queue='tareas',
        on_message_callback=callback,
        auto_ack=False
    )

    print("Worker esperando mensajes...")
    channel.start_consuming()


main()