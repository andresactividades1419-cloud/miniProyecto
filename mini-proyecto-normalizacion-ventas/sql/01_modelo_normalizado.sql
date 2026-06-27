-- 1. Creación del esquema del negocio
CREATE SCHEMA IF NOT EXISTS normalizacion_ventas;
SET search_path TO normalizacion_ventas;

-- Limpieza previa para permitir re-ejecución 
DROP TABLE IF EXISTS detalle_ventas CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;

-- 2. Tabla de Categorías
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
);

-- 3. Tabla de Productos
CREATE TABLE productos (
    producto_codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    CONSTRAINT fk_productos_categorias FOREIGN KEY (categoria_id) 
        REFERENCES categorias(categoria_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. Tabla de Clientes
CREATE TABLE clientes (
    cliente_doc VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    direccion VARCHAR(150),
    ciudad VARCHAR(80)
);

-- 5. Tabla de Vendedores
CREATE TABLE vendedores (
    vendedor_id VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona VARCHAR(80) NOT NULL
);

-- 6. Tabla de Ventas (Cabecera)
CREATE TABLE ventas (
    venta_id VARCHAR(10) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    cliente_doc VARCHAR(20) NOT NULL,
    vendedor_id VARCHAR(10) NOT NULL,
    metodo_pago VARCHAR(80) NOT NULL,
    entidad_pago VARCHAR(80),
    CONSTRAINT fk_ventas_clientes FOREIGN KEY (cliente_doc) 
        REFERENCES clientes(cliente_doc) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_vendedores FOREIGN KEY (vendedor_id) 
        REFERENCES vendedores(vendedor_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 7. Tabla de Detalle de Ventas
CREATE TABLE detalle_ventas (
    venta_id VARCHAR(10) NOT NULL,
    producto_codigo VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(12,2) NOT NULL,
    descuento NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (venta_id, producto_codigo),
    CONSTRAINT fk_detalle_ventas_ventas FOREIGN KEY (venta_id) 
        REFERENCES ventas(venta_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_ventas_productos FOREIGN KEY (producto_codigo) 
        REFERENCES productos(producto_codigo) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT chk_precio_no_negativo CHECK (precio_unitario >= 0),
    CONSTRAINT chk_descuento_no_negativo CHECK (descuento >= 0)
);
