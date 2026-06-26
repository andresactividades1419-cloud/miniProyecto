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

---

### Paso 2: Ejecución de Scripts SQL
Para cargar y validar el modelo, ejecuta los scripts dentro de tu cliente de base de datos (pgAdmin, DBeaver, psql, etc.) en el siguiente **orden secuencial estricto**:

1. **[`sql/00_tabla_cruda.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/00_tabla_cruda.sql)**  
   *Crea la tabla desnormalizada `ventas_crudas` e inserta los datos de prueba iniciales.*

2. **[`sql/01_modelo_normalizado.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/01_modelo_normalizado.sql)**  
   *Crea el esquema `normalizacion_ventas`, define las tablas en 3FN y establece las restricciones primarias, foráneas y validaciones (`CHECK`).*

3. **[`sql/02_datos_normalizados.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/02_datos_normalizados.sql)**  
   *Puebla las tablas normalizadas con los registros mapeados.*

4. **[`sql/03_consultas_validacion.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/03_consultas_validacion.sql)**  
   *Ejecuta las consultas requeridas para reconstruir ventas, validar totales y auditar la integridad referencial.*
