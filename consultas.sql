-- 03_Consultas_DQL.sql: Consultas Requeridas para Análisis
USE pizzeria_db;

-- 1. Productos más vendidos (pizza, panzarottis, bebidas, etc.)
-- Incluye productos vendidos sueltos y los incluidos dentro de combos.
WITH ProductosVendidos AS (
    SELECT id_producto, cantidad FROM pedido_producto
    UNION ALL
    SELECT cp.id_producto, (pc.cantidad * cp.cantidad) AS cantidad
    FROM pedido_combo pc
    JOIN combo_producto cp ON pc.id_combo = cp.id_combo
)
SELECT p.nombre, SUM(pv.cantidad) as total_vendidos
FROM ProductosVendidos pv
JOIN producto p ON pv.id_producto = p.id_producto
GROUP BY p.nombre
ORDER BY total_vendidos DESC;

-- 2. Total de ingresos generados por cada combo
SELECT c.nombre, SUM(pc.cantidad * pc.precio_unitario) as total_ingresos
FROM pedido_combo pc
JOIN combo c ON pc.id_combo = c.id_combo
GROUP BY c.nombre;

-- 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT tipo_entrega, COUNT(*) as total_pedidos
FROM pedido
GROUP BY tipo_entrega;

-- 4. Adiciones más solicitadas en pedidos personalizados
SELECT a.nombre, SUM(ppa.cantidad) as veces_solicitada
FROM pedido_producto_adicion ppa
JOIN adicion a ON ppa.id_adicion = a.id_adicion
GROUP BY a.nombre
ORDER BY veces_solicitada DESC;

-- 5. Cantidad total de productos vendidos por categoría
WITH ProductosVendidos AS (
    SELECT id_producto, cantidad FROM pedido_producto
    UNION ALL
    SELECT cp.id_producto, (pc.cantidad * cp.cantidad) AS cantidad
    FROM pedido_combo pc
    JOIN combo_producto cp ON pc.id_combo = cp.id_combo
)
SELECT c.nombre as categoria, SUM(pv.cantidad) as total_vendidos
FROM ProductosVendidos pv
JOIN producto p ON pv.id_producto = p.id_producto
JOIN categoria_producto c ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
ORDER BY total_vendidos DESC;

-- 6. Promedio de pizzas pedidas por cliente
WITH PizzasVendidas AS (
    SELECT p.id_cliente, pp.cantidad
    FROM pedido_producto pp
    JOIN pedido p ON pp.id_pedido = p.id_pedido
    JOIN producto prod ON pp.id_producto = prod.id_producto
    JOIN categoria_producto cat ON prod.id_categoria = cat.id_categoria
    WHERE cat.nombre = 'Pizza'
    UNION ALL
    SELECT p.id_cliente, (pc.cantidad * cp.cantidad) AS cantidad
    FROM pedido_combo pc
    JOIN pedido p ON pc.id_pedido = p.id_pedido
    JOIN combo_producto cp ON pc.id_combo = cp.id_combo
    JOIN producto prod ON cp.id_producto = prod.id_producto
    JOIN categoria_producto cat ON prod.id_categoria = cat.id_categoria
    WHERE cat.nombre = 'Pizza'
)
SELECT SUM(cantidad) / (SELECT COUNT(id_cliente) FROM cliente) as promedio_pizzas_por_cliente
FROM PizzasVendidas;

-- 7. Total de ventas por día de la semana
SELECT DAYNAME(fecha_hora) as dia_semana, SUM(total) as total_ventas
FROM pedido
GROUP BY dia_semana
ORDER BY total_ventas DESC;

-- 8. Cantidad de panzarottis vendidos con extra queso
SELECT SUM(pp.cantidad) as panzarottis_extra_queso
FROM pedido_producto pp
JOIN producto p ON pp.id_producto = p.id_producto
JOIN categoria_producto cp ON p.id_categoria = cp.id_categoria
JOIN pedido_producto_adicion ppa ON pp.id_pedido_producto = ppa.id_pedido_producto
JOIN adicion a ON ppa.id_adicion = a.id_adicion
WHERE cp.nombre = 'Panzarotti' AND a.nombre = 'Extra Queso';

-- 9. Pedidos que incluyen bebidas como parte de un combo
SELECT DISTINCT pc.id_pedido
FROM pedido_combo pc
JOIN combo_producto cp ON pc.id_combo = cp.id_combo
JOIN producto p ON cp.id_producto = p.id_producto
JOIN categoria_producto cat ON p.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Bebida';

-- 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT c.nombre, COUNT(p.id_pedido) as total_pedidos
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
WHERE p.fecha_hora >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY c.id_cliente
HAVING total_pedidos > 5;

-- 11. Ingresos totales generados por productos no elaborados (bebidas, postres, etc.)
-- Solo se cuenta la venta individual, los combos tienen precio global
SELECT SUM(pp.cantidad * pp.precio_unitario) as ingresos_no_elaborados
FROM pedido_producto pp
JOIN producto p ON pp.id_producto = p.id_producto
WHERE p.elaborado = 0;

-- 12. Promedio de adiciones por pedido
SELECT SUM(cantidad) / (SELECT COUNT(id_pedido) FROM pedido) as promedio_adiciones_por_pedido
FROM pedido_producto_adicion;

-- 13. Total de combos vendidos en el último mes
SELECT SUM(pc.cantidad) as total_combos_mes
FROM pedido_combo pc
JOIN pedido p ON pc.id_pedido = p.id_pedido
WHERE p.fecha_hora >= DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT c.nombre
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente
HAVING SUM(CASE WHEN p.tipo_entrega = 'Recoger' THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN p.tipo_entrega = 'Local' THEN 1 ELSE 0 END) > 0;

-- 15. Total de productos personalizados con adiciones
SELECT COUNT(DISTINCT id_pedido_producto) as total_productos_personalizados
FROM pedido_producto_adicion;

-- 16. Pedidos con más de 3 productos diferentes
SELECT id_pedido, COUNT(DISTINCT id_producto) as productos_diferentes
FROM (
    SELECT id_pedido, id_producto FROM pedido_producto
    UNION
    SELECT pc.id_pedido, cp.id_producto 
    FROM pedido_combo pc
    JOIN combo_producto cp ON pc.id_combo = cp.id_combo
) as productos_por_pedido
GROUP BY id_pedido
HAVING productos_diferentes > 3;

-- 17. Promedio de ingresos generados por día
SELECT AVG(ingreso_diario) as promedio_ingresos_dia
FROM (
    SELECT DATE(fecha_hora) as dia, SUM(total) as ingreso_diario
    FROM pedido
    GROUP BY DATE(fecha_hora)
) as ingresos_por_dia;

-- 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
WITH PedidosPizzaAdicion AS (
    SELECT DISTINCT p.id_pedido, p.id_cliente
    FROM pedido p
    JOIN pedido_producto pp ON p.id_pedido = pp.id_pedido
    JOIN producto prod ON pp.id_producto = prod.id_producto
    JOIN categoria_producto cat ON prod.id_categoria = cat.id_categoria
    JOIN pedido_producto_adicion ppa ON pp.id_pedido_producto = ppa.id_pedido_producto
    WHERE cat.nombre = 'Pizza'
),
EstadisticasCliente AS (
    SELECT 
        c.id_cliente,
        c.nombre,
        COUNT(DISTINCT p.id_pedido) as total_pedidos,
        COUNT(DISTINCT ppa.id_pedido) as pedidos_pizza_adicion
    FROM cliente c
    JOIN pedido p ON c.id_cliente = p.id_cliente
    LEFT JOIN PedidosPizzaAdicion ppa ON p.id_pedido = ppa.id_pedido
    GROUP BY c.id_cliente
)
SELECT nombre, total_pedidos, pedidos_pizza_adicion
FROM EstadisticasCliente
WHERE pedidos_pizza_adicion > (total_pedidos * 0.5);

-- 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT 
    (SUM(CASE WHEN p.elaborado = 0 THEN pp.cantidad * pp.precio_unitario ELSE 0 END) / 
    (SELECT SUM(total) FROM pedido)) * 100 as porcentaje_no_elaborados
FROM pedido_producto pp
JOIN producto p ON pp.id_producto = p.id_producto;

-- 20. Día de la semana con mayor número de pedidos para recoger
SELECT DAYNAME(fecha_hora) as dia_semana, COUNT(*) as total_recoger
FROM pedido
WHERE tipo_entrega = 'Recoger'
GROUP BY dia_semana
ORDER BY total_recoger DESC
LIMIT 1;
