# Mini Proyecto: Normalización de un Sistema de Ventas

Este repositorio contiene la solución completa para la normalización de la base de datos de la empresa ficticia **Ventas Express S.A.S.**, pasando de una hoja de cálculo desnormalizada a un modelo relacional en **Tercera Forma Normal (3FN)** utilizando PostgreSQL.

---

## 1. Estructura de la Entrega

```text
mini-proyecto-normalizacion-ventas/
├── README.md                          # Este archivo (instrucciones de ejecución)
├── informe_normalizacion.md           # Informe de diagnóstico y normalización (Pasos 1 a 5)
├── entorno-postgres/
│   └── docker-compose.yml             # Infraestructura Docker (PostgreSQL + pgAdmin)
└── sql/
    ├── 00_tabla_cruda.sql             # Paso 5: Script de carga inicial desnormalizada
    ├── 01_modelo_normalizado.sql      # Paso 6: Estructura del esquema y tablas (DDL)
    ├── 02_datos_normalizados.sql      # Paso 6: Migración e inserción de datos limpios
    └── 03_consultas_validacion.sql    # Paso 7: Consultas de validación de negocio
```

---

## 2. Requisitos Previos

* Docker y Docker Compose instalados.
* Alternativamente, un servidor PostgreSQL local en ejecución.

---

## 3. Instrucciones de Ejecución

### Paso 1: Levantar el Entorno de Base de Datos
Si deseas trabajar con la infraestructura de contenedores provista, navega a la carpeta del entorno y ejecuta:
```bash
docker compose up -d
```
Esto iniciará:
1. **PostgreSQL** en el puerto `5432` (Base de datos: `ventas_normalizacion`, Usuario: `postgres`, Contraseña: `123456`).
2. **pgAdmin4** en el puerto `5050` (Email: `admin@admin.com`, Contraseña: `123456`).

> [!NOTE]
> Si anteriormente tenías contenedores creados con otra contraseña y pgAdmin no te permite iniciar sesión, ejecuta el siguiente comando en la carpeta `entorno-postgres/` para limpiar la caché de credenciales de pgAdmin sin perder tus datos de PostgreSQL:
> ```bash
> docker compose rm -f -s -v pgadmin
> docker compose up -d
> ```

---

### Paso 2: Ejecución y Validación de Scripts SQL

Para configurar la conexión en **pgAdmin** y ejecutar las consultas de validación en orden, sigue esta guía detallada:

#### **Paso A: Registrar el Servidor en pgAdmin**
1. Abre tu navegador e ingresa a: [http://localhost:5050](http://localhost:5050).
2. Inicia sesión con el correo `admin@admin.com` y la contraseña `123456`.
3. En la página de inicio, haz clic en el botón **Add New Server** (o clic derecho en *Servers* -> *Register* -> *Server...*).
4. En la pestaña **General**, escribe un nombre descriptivo (por ejemplo: `PostgreSQL Local`).
5. Ve a la pestaña **Connection** e ingresa la siguiente información:
   * **Host name/address:** `db` (se usa el nombre del servicio Docker para que se comunique internamente).
   * **Port:** `5432`
   * **Maintenance database:** `ventas_normalizacion`
   * **Username:** `postgres`
   * **Password:** `123456`
6. Haz clic en **Save**. Ahora verás el servidor disponible en el explorador de objetos de la izquierda.

#### **Paso B: Carga y Ejecución en Query Tool**
Para ejecutar cada script, debes abrir la consola de SQL de pgAdmin:
1. En el menú izquierdo, navega por el árbol: `Servers` -> `PostgreSQL Local` -> `Databases` -> `ventas_normalizacion`.
2. Haz clic derecho sobre **`ventas_normalizacion`** y selecciona **Query Tool** (o presiona `Alt + Shift + Q`).
3. Abre o copia el contenido de los archivos SQL en el orden estricto indicado abajo y presiona el botón **Execute (F5 / botón de rayo)**:
   
   1. **[`sql/00_tabla_cruda.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/00_tabla_cruda.sql)**: Crea e inserta los datos iniciales de la tabla desnormalizada `ventas_crudas`.
   2. **[`sql/01_modelo_normalizado.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/01_modelo_normalizado.sql)**: Crea las tablas de la 3FN, llaves primarias, foráneas y restricciones.
   3. **[`sql/02_datos_normalizados.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/02_datos_normalizados.sql)**: Puebla las tablas limpias mapeando los datos de `ventas_crudas`.
   4. **[`sql/03_consultas_validacion.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/03_consultas_validacion.sql)**: Ejecuta y valida las consultas requeridas por el proyecto. Verás los resultados en el panel inferior *Data Output*.
