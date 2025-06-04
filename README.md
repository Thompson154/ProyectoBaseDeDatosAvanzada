# Proyecto Base de Datos Avanzada - Videojuego (Base de Inspiracion DeadIsland2)

## Descripción
Este proyecto implementa un sistema de bases de datos distribuido para el juego Dead Island 2, utilizando múltiples motores de bases de datos para optimizar diferentes tipos de operaciones y datos.

## Arquitectura del Sistema

El proyecto utiliza una arquitectura multi-base de datos con Docker Compose para orquestación: [1](#0-0) 

### Bases de Datos Utilizadas

- **PostgreSQL**: Maneja las tablas estructurales y relacionales del juego [2](#0-1) 
- **MariaDB**: Gestiona las tablas transaccionales y logs de combate [3](#0-2) 
- **MongoDB**: Base de datos NoSQL para datos no estructurados
- **Redis**: Cache en memoria para datos de alta velocidad como un chat en vivo

## Estructura del Proyecto

```
├── docker-compose.yml          # Configuración de contenedores
├── init/
│   ├── postgres/              # Scripts de inicialización PostgreSQL
│   │   ├── 01-postgres-deadisland-createTables.sql
│   │   ├── 02-postgres-createData.sql
│   │   ├── 03-postgres-vistas.sql
|   |   ├── 04-postgres-particiones.sql
|   |   ├── 05-postgres-SPs.sql
│   │   ├── 06-postgres-triggers.sql
│   │   ├── 07-postgres-functions.sql
|   |   ├── 08-postgres-indices.sql
│   │   └── 09-postgres-ofuscamiento.sql
│   └── mariadb/               # Scripts de inicialización MariaDB
│   │   ├── 01-mariadb-deadisland-createTables.sql
│   │   ├── 02-mariadb-createData.sql
│   │   ├── 03-mariadb-vistas.sql
|   |   ├── 04-mariadb-particiones.sql
|   |   ├── 05-mariadb-SPs.sql
│   │   ├── 06-mariadb-triggers.sql
│   │   ├── 07-mariadb-functions.sql
|   |   ├── 08-mariadb-indices.sql
│   │   └── 09-mariadb-ofuscamiento.sql
├── backupDeadIsland2/         # Scripts y archivos de respaldo
└── package.json  # Aca se encuentran script para hacelerar el levantamiento del docker

```

## Funcionalidades Implementadas

### PostgreSQL - Datos Estructurales
- Gestión de jugadores, mapas, enemigos y misiones [4](#0-3) 
- Triggers para validación de datos [5](#0-4) 
- Procedimientos almacenados para operaciones complejas

### MariaDB - Datos Transaccionales
- Logs de partidas y combates [6](#0-5) 
- Eventos de zombis y recompensas [7](#0-6) 
- Procedimientos para inserción automatizada de recompensas [8](#0-7) 

### Sistema de Respaldo y Restauración
- Scripts automatizados para respaldo de datos
- Script de restauración en Node.js [9](#0-8) 

## Instalación y Configuración

### Prerrequisitos
- Docker y Docker Compose instalados
- Node.js (para scripts de restauración)

### Variables de Entorno
Crear un archivo `.env` con las siguientes variables:
```env
# PostgreSQL
POSTGRES_USER=tu_user
POSTGRES_PASSWORD=tu_password
POSTGRES_DB=videojuego

# MariaDB
MYSQL_ROOT_PASSWORD=tu_password
MYSQL_DATABASE=videojuego
MYSQL_USER=tu_user
MYSQL_PASSWORD=tu_password


# PostgreSQL
PG_CONTAINER=postgres
PG_USER=tu_user
PG_DB=videojuego
PG_TEMP_FOLDER=/tmp
PG_BACKUP_FOLDER=./backupDeadIsland2/backups/postgres

# MariaDB
MARIADB_CONTAINER=mariadb
MARIADB_USER=tu_user
MARIADB_PASSWORD=tu_password
MARIADB_DB=videojuego
MARIADB_TEMP_FOLDER=/tmp
MARIADB_BACKUP_FOLDER=./backupDeadIsland2/backups/mariadb

# MongoDB
MONGO_CONTAINER=mongo
MONGO_DB=mongo
MONGO_TEMP_FOLDER=/tmp
MONGO_BACKUP_FOLDER=./backupDeadIsland2/backups/mongo

# Redis
REDIS_CONTAINER=redis
REDIS_TEMP_FOLDER=/data
REDIS_BACKUP_FOLDER=./backupDeadIsland2/backups/redis

```

### Iniciar el Sistema
```bash
    "dev": Para levantar el proyecto el docker
    "stop": Para apagar los docker
    "stop2": Para matar a los docker
    "backup": Para empezar con el backup
    "restore": Para emepzar el restore
    "rmvolumen": Para remover todos los volmenes que se crearon anteriormente
```

### Acceso a las Bases de Datos
- **PostgreSQL**: Puerto 5432
- **MariaDB**: Puerto 3306
- **MongoDB**: Puerto 27017
- **Redis**: Puerto 6379

## Modelo de Datos

### Entidades Principales (PostgreSQL)
- **Jugadores**: Información de usuarios del juego
- **Mapas**: Zonas y ubicaciones del juego
- **Enemigos**: Zombis y criaturas
- **Misiones**: Tareas y objetivos del juego
- **Inventario**: Items y equipamiento de jugadores

### Logs Transaccionales (MariaDB)
- **Partidas**: Registro de sesiones de juego
- **Log de Combate**: Acciones detalladas de combate
- **Eventos**: Eventos especiales del juego
- **Recompensas**: Sistema de premios por eventos

## Características Técnicas

- Distribución de datos según tipo y uso
- Triggers para validación automática de datos
- Procedimientos almacenados para operaciones complejas
- Sistema automatizado de respaldos
- Arquitectura escalable con Docker
