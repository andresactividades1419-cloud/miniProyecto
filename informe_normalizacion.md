# Informe de Normalización de Base de Datos - Sistema de Ventas
**Curso:** Bases de Datos Relacionales con PostgreSQL  
**Módulo:** 2 - Normalización  
**Empresa:** Ventas Express S.A.S.  

---

## Paso 1. Diagnóstico de la Tabla Cruda

### 1.1. Identificación de Atributos No Atómicos
En la tabla inicial `ventas_crudas` se identifican varias columnas que contienen múltiples valores separados por comas dentro de una misma celda, rompiendo la primera regla de una base de datos relacional:
* `productos_codigos` (ej. `'P001,P002'`)
* `productos_nombres` (ej. `'Mouse USB,Teclado mecanico'`)
* `categorias` (ej. `'Perifericos,Perifericos'`)
* `cantidades` (ej. `'2,1'`)
* `precios_unitarios` (ej. `'45000,180000'`)
* `descuentos` (ej. `'0,0'`)

### 1.2. Datos Repetidos (Redundancia)
Se evidencia una repetición excesiva de datos en cada registro:
* **Por Cliente:** Para el cliente Maria Gomez (`CC101`), se repiten en cada compra su nombre, dirección, ciudad, correo y teléfono.
* **Por Vendedor:** Para el vendedor `VEN01`, se repite su nombre (Ana Torres) y su zona (Norte) en cada venta realizada por ella.
* **Por Producto:** El nombre del producto y su categoría se repiten cada vez que se vende el artículo.
* **Por Pago:** Se repiten combinaciones de método de pago y entidad bancaria (ej. `Transferencia` y `Bancolombia`).

### 1.3. Anomalías del Modelo Desnormalizado
* **Anomalía de Inserción:** No es posible registrar un nuevo cliente en el sistema si este no ha realizado al menos una compra, dado que la tabla exige un `venta_id`. Lo mismo ocurre con un nuevo vendedor o un nuevo producto.
* **Anomalía de Actualización:** Si un cliente cambia su número de teléfono, es necesario buscar y modificar todas las filas históricas en las que ha aparecido. De lo contrario, la base de datos quedará en un estado inconsistente.
* **Anomalía de Eliminación:** Si se cancela y se elimina la única compra realizada por un cliente (por ejemplo, Laura Rojas), se perderán permanentemente todos sus datos personales del sistema.

### 1.4. Lista Inicial de Dependencias Funcionales
* `cliente_doc` $\rightarrow$ `cliente_nombre`, `cliente_email`, `cliente_telefono`, `cliente_direccion`, `cliente_ciudad`
* `vendedor_id` $\rightarrow$ `vendedor_nombre`, `vendedor_zona`
* `producto_codigo` $\rightarrow$ `producto_nombre`, `categoria`
* `venta_id` $\rightarrow$ `fecha_venta`, `cliente_doc`, `vendedor_id`, `metodo_pago`, `entidad_pago`

---

## Paso 2. Aplicación de la Primera Forma Normal (1FN)

### 2.1. Transformación a Registros Separados
Se eliminan todas las listas separadas por comas. Cada elemento de las celdas multivaluadas se expande verticalmente en una fila independiente.

### 2.2. Clave Compuesta Provisional
Dado que un mismo `venta_id` ahora se repite para agrupar los diferentes artículos de una compra, se propone la siguiente clave primaria compuesta:
$$\text{PK Provisional} = (\text{venta\_id}, \text{producto\_codigo})$$

---

## Paso 3. Aplicación de la Segunda Forma Normal (2FN)

### 3.1. Evaluación de Dependencias Parciales
En la tabla de 1FN con clave primaria compuesta `(venta_id, producto_codigo)`, existen atributos que no dependen de la clave completa, sino de una parte de ella:
* Los datos del cliente, vendedor y de la transacción dependen únicamente de `venta_id` (dependencia parcial).
* El nombre del producto y su categoría dependen únicamente de `producto_codigo` (dependencia parcial).

### 3.2. Separación de Entidades y Definición de Claves (2FN)
Se fragmenta la tabla en las siguientes entidades independientes:

1. **Tabla `cliente`**
   * **PK:** `cliente_doc`
2. **Tabla `vendedor`**
   * **PK:** `vendedor_id`
3. **Tabla `producto`**
   * **PK:** `producto_codigo`
   * *Atributos:* `nombre`, `categoria`
4. **Tabla `venta`**
   * **PK:** `venta_id`
   * **FKs:** `cliente_doc` (apunta a `cliente`), `vendedor_id` (apunta a `vendedor`)
5. **Tabla `detalle_venta`**
   * **PK:** `(venta_id, producto_codigo)`
   * **FK1:** `venta_id` (apunta a `venta`)
   * **FK2:** `producto_codigo` (apunta a `producto`)
   * *Atributos propios:* `cantidad`, `precio_unitario`, `descuento` (estos tres dependen de la combinación de la venta y el producto).

---

## Paso 4. Aplicación de la Tercera Forma Normal (3FN)

### 4.1. Eliminación de Dependencias Transitivas
En la entidad `producto`, se identifica que la columna `categoria` depende directamente del producto, pero a su vez describe un concepto independiente que genera redundancia si varios productos pertenecen a ella. Se decide extraerla:
* **Nueva Tabla `categorias`:**
  * **PK:** `categoria_id` (Autoincremental/SERIAL)
  * *Atributos:* `nombre`
* **Tabla `productos` (Modificada):**
  * **PK:** `producto_codigo`
  * **FK:** `categoria_id` (apunta a `categorias`)
  * *Atributos:* `nombre`

### 4.2. Justificación de Atributos Planos (Ciudades y Zonas)
* **Ciudades (en Clientes):** Se decide no separarlo en una tabla catálogo porque los datos actuales de ciudades son simples cadenas informativas del domicilio del cliente y no requieren un mantenimiento de catálogo independiente en esta escala.
* **Zonas (en Vendedores):** Se mantiene dentro de la tabla de vendedores como un atributo descriptivo básico de su área operativa principal.

### 4.3. Validación de la Regla de Oro
* Cada atributo no clave de las tablas resultantes depende **única y exclusivamente** de la clave primaria correspondiente (dependencia funcional directa y completa).

---

## Paso 5. Diseño del Modelo Entidad-Relación

Las cardinalidades y relaciones lógicas establecidas son:
1. **Categorías a Productos:** Una categoría tiene muchos productos ($1:N$).
2. **Clientes a Ventas:** Un cliente puede realizar muchas compras ($1:N$).
3. **Vendedores a Ventas:** Un vendedor puede atender muchas ventas ($1:N$).
4. **Ventas a Detalles:** Una venta tiene uno o muchos detalles ($1:N$).
5. **Productos a Detalles:** Un producto puede registrarse en múltiples líneas de detalle de diferentes ventas ($1:N$).
