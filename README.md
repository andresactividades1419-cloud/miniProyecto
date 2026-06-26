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

> [!IMPORTANT]
> PostgreSQL solo lee la variable `POSTGRES_PASSWORD` la primera vez que se crea el volumen. Si ya tenías contenedores inicializados anteriormente y deseas cambiar la contraseña de PostgreSQL o pgAdmin a `123456`, debes restablecer por completo los volúmenes ejecutando en la carpeta `entorno-postgres/`:
> ```bash
> docker compose down -v
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

#### **Paso B: Carga y Creación del Modelo**
Para ejecutar los scripts de creación de tablas y carga de datos:
1. En el menú izquierdo de pgAdmin, despliega el árbol: `Servers` -> `PostgreSQL Local` -> `Databases` -> `ventas_normalizacion`.
2. Haz clic derecho sobre **`ventas_normalizacion`** y selecciona **Query Tool** (o presiona `Alt + Shift + Q`).
3. Abre, copia y ejecuta en orden secuencial estricto los siguientes archivos (presionando el botón de **rayo / Execute** o `F5`):
   
   * **1. [`sql/00_tabla_cruda.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/00_tabla_cruda.sql)**: Crea e inserta los datos crudos originales de la hoja de cálculo.
   * **2. [`sql/01_modelo_normalizado.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/01_modelo_normalizado.sql)**: Elimina y crea la estructura relacional limpia en 3FN (tablas con llaves y restricciones).
   * **3. [`sql/02_datos_normalizados.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/02_datos_normalizados.sql)**: Puebla la base de datos limpia con los registros de prueba mapeados.

---

#### **Paso C: Ejecución Paso a Paso de las Consultas de Validación**
Una vez pobladas las tablas, abre el archivo **[`sql/03_consultas_validacion.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/sql/03_consultas_validacion.sql)** en el Query Tool. 

Para ejecutar cada consulta de forma independiente en pgAdmin, **sombrea (selecciona con el mouse) únicamente el bloque de la consulta que quieres probar** y presiona **F5** (o el botón de ejecutar). pgAdmin solo ejecutará el texto seleccionado:

* **Consulta 1: Total calculado por cada venta desde el detalle**
  * *Acción:* Selecciona desde `SELECT` hasta `ORDER BY` en el primer bloque.
  * *Propósito:* Verifica que la suma de `cantidad * precio_unitario - descuento` por cada venta coincida con los totales de la tabla cruda (por ejemplo, `V1001` debe dar `270000.00`).
  
* **Consulta 2: Productos más vendidos por cantidad total**
  * *Acción:* Sombrea la segunda consulta SELECT.
  * *Propósito:* Agrupa y suma la cantidad vendida de cada producto para identificar los más populares.
  
* **Consulta 3: Ventas por vendedor**
  * *Acción:* Selecciona y ejecuta el tercer bloque de la consulta.
  * *Propósito:* Muestra la cantidad total de facturas distintas y el valor monetario neto facturado por cada vendedor.
  
* **Consulta 4: Historial de compras de un cliente específico**
  * *Acción:* Sombrea la cuarta consulta.
  * *Propósito:* Filtra y despliega de manera cronológica el desglose de productos comprados por el cliente `CC101` (Maria Gomez). Puedes cambiar el valor `'CC101'` por otro documento de cliente para probar.
  
* **Consulta 5: Control de integridad (Auditoría de registros huérfanos)**
  * *Acción:* Sombrea la quinta y última consulta.
  * *Propósito:* Realiza un cruce de datos para confirmar que no existen líneas de detalles sin una venta o un producto asociado. El resultado esperado en el contador es **`0`**.
