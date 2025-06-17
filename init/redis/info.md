# Sistema de Caché para Estadísticas de Jugadores e Inventarios

Este documento describe el sistema de caché implementado para `player_stats` e `inventory`/`inventory_items` usando Redis y PostgreSQL, siguiendo el patrón Cache-Aside (Interacción entre Redis y PostGres) para lecturas y un enfoque Write-Through (Correlación de Datos entre Redis y Postgres)para escrituras. El sistema está construido en Node.js, con TTLs específicos y políticas de expiración.

## Componentes

### Cliente (Jugador/Juego)
- Envía solicitudes al backend para obtener (`GET`) datos de `player_stats` o `inventory`/`inventory_items`, o para actualizar (`SET`) datos.

### Aplicación (Backend)
- Implementa la lógica en Node.js con funciones:
  - `getPlayer`
  - `getPlayerCache`
  - `getPlayerDB`
  - `setPlayer`
  - `setPlayerCache`
- Usa el patrón **Cache-Aside** para lecturas y actualiza Redis tras escrituras.

### Redis (Caché)
- Almacena datos con las siguientes claves:
  - `player_stats:{player_id}` (TTL: 30 segundos)
  - `inventory:{player_id}:capacity` (TTL: 60 segundos)
  - `inventory_items:{player_id}` (TTL: 60 segundos)
- Usa `setEx` para establecer datos con TTLs.

### PostgreSQL (Base de Datos)
- Contiene las tablas:
  - `player_stats`
  - `inventories`
  - `inventory_items`
- Consultada durante cache misses o para operaciones de escritura.

## Flujo de Operaciones

### Lectura (Cache-Aside)
1. **Paso 1**: El cliente solicita datos (por ejemplo, `GET player_stats` para `player_id = 123`).
2. **Paso 2 (a)**: El backend llama a `getPlayer(redisKey)` con `redisKey = player_stats:123`.
3. **Paso 3 (b)**: `getPlayerCache` consulta Redis (`client.get(redisKey)`).
   - **Cache Hit**: Si los datos existen, se parsean (`JSON.parse`) y se devuelven.
   - **Cache Miss**: Si no existen, se pasa al Paso 4.
4. **Paso 4 (c)**: `getPlayerDB` consulta PostgreSQL (por ejemplo, `SELECT * FROM player_stats WHERE player_id = 123`).
5. **Paso 5 (d)**: Los datos se almacenan en Redis con `setPlayerCache` (`client.setEx(redisKey, TTL, JSON.stringify(data))`).
   - TTL: 30 segundos para `player_stats`, 60 segundos para `inventory`/`inventory_items`.
6. **Paso 6 (e)**: Los datos se devuelven al cliente.

### Escritura
1. **Paso 1 (f)**: El cliente envía una solicitud de escritura (por ejemplo, `setPlayer(data)` para actualizar `player_stats` o `inventory_items`).
2. **Paso 2**: `setPlayer` actualiza PostgreSQL (implícito en la lógica de `setStudentData`).
3. **Paso 3 (g)**: Si la escritura es exitosa, `setPlayerCache` actualiza Redis con `client.setEx(redisKey, TTL, JSON.stringify(data))`.
4. **Paso 4**: La operación se confirma al cliente.

## Políticas de Expiración

### Expiración Natural
- Las claves expiran tras su TTL:
  - 30 segundos para `player_stats`
  - 60 segundos para `inventory`/`inventory_items`
- Implementado usando `client.setEx`.

### Invalidación/Actualización
- Durante escrituras, Redis se actualiza con los nuevos datos vía `setPlayerCache`, en lugar de invalidarse, siguiendo el enfoque del código (`setStudentCache`).

### Eviction
- No especificado en el código; se asume la configuración predeterminada de Redis.
- Opcionalmente, configurar `maxmemory-policy allkeys-lru` para eliminación de claves menos usadas si se alcanza el límite de memoria.

## Justificación de los TTLs

- **TTL de 30 segundos para `player_stats`**:
  - Las estadísticas (`hp`, `stamina`, `level`, `xp`) se consultan frecuentemente durante el juego (por ejemplo, en combates o regeneración). Cambian con frecuencia moderada, pero una desactualización de hasta 30 segundos es aceptable para la experiencia del jugador. Este TTL reduce la carga en PostgreSQL manteniendo datos razonablemente frescos.
  
- **TTL de 60 segundos para `inventory`/`inventory_items`**:
  - Los inventarios cambian menos frecuentemente (al recoger, usar o descartar objetos) y se consultan con alta frecuencia. Un TTL de 60 segundos minimiza consultas a PostgreSQL, ya que los datos son más estables, y sigue siendo lo suficientemente corto para reflejar cambios en un tiempo razonable.

- **Razón general**:
  - Los TTLs se eligen según la frecuencia de lectura vs. escritura y la tolerancia a la desactualización. Un TTL corto para `player_stats` asegura frescura en escenarios dinámicos (como combates), mientras que un TTL más largo para `inventory`/`inventory_items` optimiza el rendimiento para datos más estables.