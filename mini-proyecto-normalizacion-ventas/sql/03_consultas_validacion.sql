SET search_path TO normalizacion_ventas;

SELECT 
    venta_id,
    SUM(cantidad * precio_unitario - descuento) AS total_calculado
FROM detalle_ventas
GROUP BY venta_id
ORDER BY venta_id;

SELECT 
    p.producto_codigo,
    p.nombre AS producto_nombre,
    SUM(dv.cantidad) AS unidades_vendidas
FROM detalle_ventas dv
JOIN productos p ON dv.producto_codigo = p.producto_codigo
GROUP BY p.producto_codigo, p.nombre
ORDER BY unidades_vendidas DESC;

-- 3. Ventas por vendedor
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

-
-- 4. Historial de compras de un cliente específico 
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

-- 5. Control de integridad: detalles sin venta o sin producto 
SELECT COUNT(*) AS registros_huerfanos
FROM detalle_ventas dv
LEFT JOIN ventas v ON dv.venta_id = v.venta_id
LEFT JOIN productos p ON dv.producto_codigo = p.producto_codigo
WHERE v.venta_id IS NULL OR p.producto_codigo IS NULL;
