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
   
   * **1. [`sql/00_tabla_cruda.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/mini-proyecto-normalizacion-ventas/sql/00_tabla_cruda.sql)**: Crea e inserta los datos crudos originales de la hoja de cálculo.
   * **2. [`sql/01_modelo_normalizado.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/mini-proyecto-normalizacion-ventas/sql/01_modelo_normalizado.sql)**: Elimina y crea la estructura relacional limpia en 3FN (tablas con llaves y restricciones).
   * **3. [`sql/02_datos_normalizados.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/mini-proyecto-normalizacion-ventas/sql/02_datos_normalizados.sql)**: Puebla la base de datos limpia con los registros de prueba mapeados.

---

#### **Paso C: Ejecución Paso a Paso de las Consultas de Validación**
Una vez pobladas las tablas, puedes abrir y ejecutar el archivo **[`sql/03_consultas_validacion.sql`](file:///c:/Users/andre/OneDrive/Desktop/miniProyecto/mini-proyecto-normalizacion-ventas/sql/03_consultas_validacion.sql)** en el Query Tool, o bien copiar y ejecutar directamente los siguientes bloques completos de consulta uno por uno:

> [!NOTE]
> Todos los bloques SQL de abajo incluyen la instrucción `SET search_path TO normalizacion_ventas;` para garantizar que pgAdmin sepa en qué esquema trabajar.

* **Consulta 1: Total calculado por cada venta desde el detalle**
  * *Explicación:* Suma el total neto de los productos de cada venta (`cantidad * precio_unitario - descuento`) agrupándolos por el identificador de venta. Coincide con el total del documento original.
  * *Código completo a copiar:*
    ```sql
    SET search_path TO normalizacion_ventas;
    
    SELECT 
        venta_id,
        SUM(cantidad * precio_unitario - descuento) AS total_calculado
    FROM detalle_ventas
    GROUP BY venta_id
    ORDER BY venta_id;
    ```

* **Consulta 2: Productos más vendidos por cantidad total**
  * *Explicación:* Suma las unidades vendidas de cada producto agrupándolas por su código y nombre, ordenándolas de mayor a menor cantidad.
  * *Código completo a copiar:*
    ```sql
    SET search_path TO normalizacion_ventas;
    
    SELECT 
        p.producto_codigo,
        p.nombre AS producto_nombre,
        SUM(dv.cantidad) AS unidades_vendidas
    FROM detalle_ventas dv
    JOIN productos p ON dv.producto_codigo = p.producto_codigo
    GROUP BY p.producto_codigo, p.nombre
    ORDER BY unidades_vendidas DESC;
    ```

* **Consulta 3: Ventas por vendedor**
  * *Explicación:* Muestra la cantidad total de facturas únicas atendidas y el valor acumulado facturado (neto) por cada vendedor.
  * *Código completo a copiar:*
    ```sql
    SET search_path TO normalizacion_ventas;
    
    SELECT 
        v.vendedor_id,
        v.nombre AS vendedor_nombre,
        COUNT(DISTINCT ve.venta_id) AS cantidad_ventas,
        SUM(dv.cantidad * dv.precio_unitario - dv.descuento) AS valor_total
    FROM vendedores v
    LEFT JOIN ventas ve ON v.vendedor_id = ve.vendedor_id
    LEFT JOIN detalle_ventas dv ON ve.venta_id = dv.venta_id
    GROUP BY v.vendedor_id, v.nombre
    ORDER BY valor_total DESC;
    ```

* **Consulta 4: Historial de compras de un cliente específico**
  * *Explicación:* Filtra y despliega de manera cronológica el desglose de productos comprados por un cliente (ej. `CC101` - Maria Gomez).
  * *Código completo a copiar:*
    ```sql
    SET search_path TO normalizacion_ventas;
    
    SELECT 
        c.cliente_doc,
        c.nombre AS cliente_nombre,
        v.venta_id,
        v.fecha_venta,
        p.nombre AS producto,
        dv.cantidad
    FROM clientes c
    JOIN ventas v ON c.cliente_doc = v.cliente_doc
    JOIN detalle_ventas dv ON v.venta_id = dv.venta_id
    JOIN productos p ON dv.producto_codigo = p.producto_codigo
    WHERE c.cliente_doc = 'CC101'
    ORDER BY v.fecha_venta, p.nombre;
    ```

* **Consulta 5: Control de integridad (Auditoría de registros huérfanos)**
  * *Explicación:* Realiza un cruce de datos para confirmar que no existen líneas de detalles sin una venta o un producto asociado. El resultado esperado en el contador es **`0`**.
  * *Código completo a copiar:*
    ```sql
    SET search_path TO normalizacion_ventas;
    
    SELECT COUNT(*) AS registros_huerfanos
    FROM detalle_ventas dv
    LEFT JOIN ventas v ON dv.venta_id = v.venta_id
    LEFT JOIN productos p ON dv.producto_codigo = p.producto_codigo
    WHERE v.venta_id IS NULL OR p.producto_codigo IS NULL;
    ```
