# Instalar posgresSQL
sudo apt install postgresql postgresql-contrib

# Entrar al cliente
sudo -u postgres psql

# Crear base de datos, usuario y asignar privilegios
CREATE DATABASE mi_base_de_datos;
CREATE USER mi_usuario WITH PASSWORD 'mi_password';
GRANT ALL PRIVILEGES ON DATABASE mi_base_de_datos TO mi_usuario;
\q

# Instalar librerias de Python
pip install psycopg2-binary    # driver para comunicar python con PostgresSQL 
pip install sqlalchemy         # traduce lenguaje SQL a más alto nivel 




# Peeeeero hagamoslo con un Entorno virtual
### crearlo
python3 -m venv tareas_db/venv 
### activarlo               
source tareas_db/venv/bin/activate   
### instalar dependecnais         
pip install psycopg2-binary sqlalchemy        

### creo la db
sudo -u postgres psql -c "CREATE DATABASE tareas_db;"
### creo mi usuario y contraseña
sudo -u postgres psql -c "CREATE USER mi_usuario WITH PASSWORD 'mi_password';"    
### doy permisos
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE tareas_db TO mi_usuario;"     
sudo -u postgres psql -d tareas_db -c "GRANT ALL ON SCHEMA public TO mi_usuario;"




