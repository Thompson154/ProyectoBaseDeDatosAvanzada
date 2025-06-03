# Proyecto Base de Datos Avanzada - Dead Island 2

## Descripción
Este proyecto implementa un sistema de bases de datos distribuido para el juego Dead Island 2, utilizando múltiples motores de bases de datos para optimizar diferentes tipos de operaciones y datos.

## Arquitectura del Sistema

El proyecto utiliza una arquitectura multi-base de datos con Docker Compose para orquestación: [1](#0-0) 

### Bases de Datos Utilizadas

- **PostgreSQL**: Maneja las tablas estructurales y relacionales del juego [2](#0-1) 
- **MariaDB**: Gestiona las tablas transaccionales y logs de combate [3](#0-2) 
- **MongoDB**: Base de datos NoSQL para datos no estructurados
- **Redis**: Cache en memoria para datos de alta velocidad

## Estructura del Proyecto

```
├── docker-compose.yml          # Configuración de contenedores
├── init/
│   ├── postgres/              # Scripts de inicialización PostgreSQL
│   │   ├── 01-postgres-deadisland-createTables.sql
│   │   ├── 02-postgres-createData.sql
│   │   ├── 05-postgres-triggers.sql
│   │   └── 06-postgres-SPs.sql
│   └── mariadb/               # Scripts de inicialización MariaDB
│       ├── 01-mariadb-deadisland-createTables.sql
│       ├── 02-mariadb-createData.sql
│       └── 05-mariadb-SPs.sql
├── backupDeadIsland2/         # Scripts y archivos de respaldo
├── insertar_recompensas_evento.sql
└── restore (1).js            # Script de restauración
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
POSTGRES_USER=tu_usuario_pg
POSTGRES_PASSWORD=tu_password_pg
POSTGRES_DB=deadisland2
MYSQL_ROOT_PASSWORD=tu_root_password
MYSQL_DATABASE=deadisland2
MYSQL_USER=tu_usuario_mysql
MYSQL_PASSWORD=tu_password_mysql
```

### Iniciar el Sistema
```bash
docker-compose up -d
```

### Acceso a las Bases de Datos
- **PostgreSQL**: Puerto 5432
- **MariaDB**: Puerto 3306
- **MongoDB**: Puerto 27017
- **Redis**: Puerto 6379

## Uso

### Scripts de Inicialización
Los scripts de inicialización se ejecutan automáticamente al levantar los contenedores por primera vez, creando todas las tablas, datos de prueba, triggers y procedimientos almacenados necesarios.

### Restauración de Respaldos
Para restaurar un respaldo de PostgreSQL:
```bash
node "restore (1).js"
```

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

## Notes
Este proyecto demuestra el uso de múltiples sistemas de gestión de bases de datos en una arquitectura distribuida, donde cada motor se especializa en un tipo específico de datos y operaciones. PostgreSQL maneja las relaciones complejas del juego, mientras que MariaDB se encarga de los logs y transacciones de alta frecuencia.
