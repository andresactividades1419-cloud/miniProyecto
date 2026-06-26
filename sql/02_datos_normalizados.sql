SET search_path TO normalizacion_ventas;

-- 1. Inserción de Categorías
INSERT INTO categorias (nombre) VALUES 
('Perifericos'),
('Pantallas'),
('Computadores'),
('Accesorios');

-- 2. Inserción de Productos
INSERT INTO productos (producto_codigo, nombre, categoria_id) VALUES 
('P001', 'Mouse USB', 1),
('P002', 'Teclado mecanico', 1),
('P003', 'Monitor 24', 2),
('P004', 'Portatil 14', 3),
('P005', 'Base refrigerante', 4),
('P006', 'Webcam HD', 1);

-- 3. Inserción de Clientes
INSERT INTO clientes (cliente_doc, nombre, email, telefono, direccion, ciudad) VALUES 
('CC101', 'Maria Gomez', 'maria.gomez@mail.com', '3101112233', 'Calle 10 #5-20', 'Bogota'),
('CC102', 'Juan Perez', 'juan.perez@mail.com', '3155558899', 'Carrera 8 # 20-15', 'Bogota'),
('CC103', 'Laura Rojas', 'laura.rojas@mail.com', '3209994455', 'Av. 68 #45-30', 'Medellin');

-- 4. Inserción de Vendedores
INSERT INTO vendedores (vendedor_id, nombre, zona) VALUES 
('VEN01', 'Ana Torres', 'Norte'),
('VEN02', 'Carlos Ruiz', 'Centro'),
('VEN03', 'Diana Mora', 'Occidente');

-- 5. Inserción de Ventas (Cabeceras)
INSERT INTO ventas (venta_id, fecha_venta, cliente_doc, vendedor_id, metodo_pago, entidad_pago) VALUES 
('V1001', '2026-04-01', 'CC101', 'VEN01', 'Transferencia', 'Bancolombia'),
('V1002', '2026-04-02', 'CC102', 'VEN02', 'Tarjeta credito', 'Visa'),
('V1003', '2026-04-03', 'CC101', 'VEN01', 'Transferencia', 'Bancolombia'),
('V1004', '2026-04-04', 'CC103', 'VEN03', 'Efectivo', 'Caja principal');

-- 6. Inserción de Detalles de Ventas (Datos Atómicos)
INSERT INTO detalle_ventas (venta_id, producto_codigo, cantidad, precio_unitario, descuento) VALUES 
('V1001', 'P001', 2, 45000.00, 0.00),
('V1001', 'P002', 1, 180000.00, 0.00),
('V1002', 'P003', 1, 720000.00, 20000.00),
('V1002', 'P001', 1, 45000.00, 0.00),
('V1003', 'P004', 1, 2450000.00, 50000.00),
('V1003', 'P002', 2, 180000.00, 0.00),
('V1003', 'P005', 1, 95000.00, 0.00),
('V1004', 'P003', 2, 720000.00, 0.00),
('V1004', 'P006', 1, 150000.00, 10000.00);
