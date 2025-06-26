


# Proyecto Base de Datos Avanzada - Dead Island 2

## 📋 Descripción General

Este proyecto implementa un sistema de base de datos distribuido para el videojuego Dead Island 2, utilizando múltiples motores de base de datos con arquitectura de contenedores Docker. El sistema maneja datos de jugadores, misiones, enemigos, mapas y eventos del juego mediante una arquitectura de persistencia poliglota.

## 🏗️ Arquitectura del Sistema

### Bases de Datos Configuradas

El proyecto utiliza cuatro sistemas de bases de datos diferentes:

- **PostgreSQL 15**: Base de datos principal para datos estructurales del juego
- **MariaDB 10.5**: Base de datos para datos transaccionales y logs 
- **MongoDB 6**: Base de datos NoSQL para datos no estructurados
- **Redis 7**: Sistema de caché y almacenamiento en memoria.

### Puertos de Conexión

- PostgreSQL: Puerto 5432
- MariaDB: Puerto 3306  
- MongoDB: Puerto 27017
- Redis: Puerto 6379

## 🗄️ Esquema de Base de Datos

### PostgreSQL - Datos Estructurales

El esquema de PostgreSQL incluye las siguientes tablas principales:

- **jugadores**: Información de los jugadores (ID, nombre, nivel, clase, experiencia)
- **mapas**: Definición de zonas y mapas del juego
- **enemigos**: Catálogo de enemigos y sus características
- **jefe_zombi**: Información específica de jefes zombi
- **misiones**: Sistema de misiones del juego
- **jugador_mision**: Log de misiones completadas por jugadores(#0-2) 

### MariaDB - Datos Transaccionales

MariaDB maneja los datos transaccionales del juego incluyendo logs de combate, sesiones de juego y eventos.

## 🔧 Scripts y Procedimientos

### Sistema de Recompensas por Eventos

El proyecto incluye un sistema automatizado para insertar recompensas de eventos que distribuye entre 1-3 recompensas por evento a jugadores aleatorios.

### Funciones y Procedimientos Almacenados

Se incluyen funciones para:
- Obtener dificultad de mapas
- Verificar si un mapa es difícil
- Agregar nuevos mapas al sistema. 

## 💾 Sistema de Backup y Restauración

### Scripts de Backup Automatizados

El sistema incluye scripts de backup automatizados con programación cron para todas las bases de datos:

- Backup de PostgreSQL en formato dump
- Backup de MariaDB en formato SQL
- Backup de MongoDB en formato archive
- Backup de Redis  

### Script de Restauración

Sistema de restauración automatizada que identifica el backup más reciente y restaura la base de datos PostgreSQL.

## 🚀 Instalación y Uso

### Prerrequisitos

- Docker y Docker Compose instalados
- Variables de entorno configuradas para cada base de datos

### Ejecución

```bash
# Levantar todos los servicios
docker-compose up -d

# Verificar servicios activos  
docker-compose ps

# Ver logs
docker-compose logs
```

### Inicialización

Los scripts de inicialización se ejecutan automáticamente al levantar los contenedores:

- PostgreSQL: Scripts en `./init/postgres/`
- MariaDB: Scripts en `./init/mariadb/`

## 📁 Estructura del Proyecto

```
├── docker-compose.yml              # Configuración de contenedores
├── init/                          # Scripts de inicialización
│   ├── postgres/                  # Scripts PostgreSQL
│   └── mariadb/                   # Scripts MariaDB
├── backupDeadIsland2/             # Sistema de backups
│   ├── scripts/                   # Scripts de backup/restore
│   └── backups/                   # Almacenamiento de backups
├── insertar_recompensas_evento.sql # Script de recompensas
└── restore (1).js                 # Script de restauración
```

## 🎮 Funcionalidades del Juego

El sistema de base de datos soporta las siguientes funcionalidades del juego Dead Island 2:

- Gestión completa de jugadores y progresión
- Sistema de mapas con diferentes zonas y dificultades  
- Catálogo de enemigos incluyendo jefes especiales
- Sistema de misiones con recompensas
- Logs de actividad de jugadores
- Sistema de eventos con recompensas aleatorias


### Iniciar el Sistema
```bash
    "dev": Para levantar el proyecto el docker
    "stop": Para apagar los docker
    "stop2": Para matar a los docker
    "backup": Para empezar con el backup
    "restore": Para emepzar el restore
    "rmvolumen": Para remover todos los volmenes que se crearon anteriormente
    "rmvolumen2": Para remover volumenes 
    "cache": Para levantar el cache
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

## Guía de Configuración del Proyecto

### Requisitos previos

- **Docker Desktop** (incluye Docker Compose)
- **Node 18** + **npm**
- **Editor/IDE** (ej. VS Code)
- Para pruebas visuales: **DataGrip** u otro cliente SQL

### 1. Preparar el entorno

| Paso | Comando / Acción | Comentario |
|------|------------------|------------|
| 1.1 | `git clone https://github.com/Thompson154/ProyectoBaseDeDatosAvanzada.git` | Clona el proyecto. |
| 1.2 | `cd ProyectoBaseDeDatosAvanzada` | Entra en la raíz. |
| 1.3 | Copia `.env.example` → `.env` y ajusta solo si necesitas puertos o contraseñas. | Las credenciales ya están pensadas para levantar todo sin colisiones. |

### 2. Arrancar todos los servicios

```bash
npm install          # Instala dependencias del CLI
npm run dev          # Ejecuta docker-compose up -d
```

#### ¿Qué hace?
Levanta:
- PostgreSQL
- MariaDB
- Redis
- Mongo

#### Comprobar estado:

```bash
docker compose ps
```

Todos los contenedores deben aparecer en “Up”. Si alguno está “Exited”, revisa logs:
```bash
docker logs <nombre-contenedor>
```

### 3. Conexión en DataGrip

#### PostgreSQL
Crea una nueva conexión:

```yaml
Host: localhost
Port: 5432
User: dbthompson
Password: thompson154
```

#### MariaDB
Crea otra conexión:

```yaml
Host: localhost
Port: 3306
User: dbthompson
Password: (la de tu .env)
```

#### Redis
Conecta con:
```yaml
redis://localhost:6379
```

> **Nota**: Las variables del archivo `.env` sirven de chuleta si olvidas algún dato.

### 4. Probar las utilidades npm

| Script | Qué hace | Cómo verificar |
|--------|----------|---------------|
| `npm run backup` | Ejecuta dump de Postgres y MariaDB (genera archivos en `/backups`) | Revisa `ls backups/` o el panel de Docker Desktop (volumen backups). |
| `npm run restore` | Restaura el último dump creando bases nuevas con sufijo `DB_SUFFIX` | Antes de lanzarlo, edita `scripts/restore.js` y sube `const DB_SUFFIX = "8";` al siguiente número libre. Tras ejecutar, DataGrip mostrará la nueva base (videojuego_8, p. ej.). |
| `npm run cache` | Inserta claves de prueba en Redis con TTL | Observa en DataGrip/Redis Explorer cómo aparecen las claves y expiran después de ~60 s. |

### 5. Checklist rápido de validación

- [ ] Contenedores up (Docker Desktop → verde).
- [ ] Bases y tablas visibles en DataGrip.
- [ ] Directorio `backups/` contiene los dumps recién creados.
- [ ] Bases numeradas (`videojuego_8`, etc.) tras `npm run restore`.
- [ ] Claves en Redis aparecen y desaparecen al correr `npm run cache`.

### 6. Problemas recurrentes y solución express

| Síntoma | Posible causa | Fix |
|---------|---------------|-----|
| “port already in use” | Otro servicio local ocupa 3306/5442 | Cambia el puerto en `.env` y en `docker-compose.yml`. |
| Contenedor `postgres` already exist | No se creo el contenedor por que otro ya esta vivo con ese nombre | `docker-compose.yml cambie el nombre del contenedor`. |
| `npm run restore` lanza error “database exists” | Olvidaste aumentar `DB_SUFFIX` | Incrementa el número, guarda y reintenta. |

![image](https://github.com/user-attachments/assets/9c750523-d015-4471-b5b3-464abeb780cb)

```
