-- 02_Datos_DML.sql: Inserción de Datos de Prueba
USE pizzeria_db;

-- 1. Categorías
INSERT INTO categoria_producto (nombre, descripcion) VALUES
('Pizza', 'Pizzas tradicionales y especiales'),
('Panzarotti', 'Panzarottis fritos al estilo tradicional'),
('Bebida', 'Gaseosas, jugos y cervezas'),
('Postre', 'Postres fríos y calientes'),
('Adición', 'Porciones extras de ingredientes');

-- 2. Ingredientes
INSERT INTO ingrediente (nombre) VALUES
('Queso Mozzarella'), ('Pepperoni'), ('Jamón'), ('Piña'), ('Champiñones'),
('Pollo'), ('Carne Molida'), ('Salsa de Tomate'), ('Masa Tradicional');

-- 3. Productos
-- elaborado=1 (Pizzas, Panzarottis), elaborado=0 (Bebidas, Postres)
INSERT INTO producto (nombre, descripcion, precio, id_categoria, elaborado, activo_menu) VALUES
('Pizza Pepperoni', 'Pizza con extra pepperoni y queso', 25000.00, 1, 1, 1),
('Pizza Hawaiana', 'Pizza con jamón y piña', 22000.00, 1, 1, 1),
('Pizza Pollo y Champiñones', 'Pizza clásica', 26000.00, 1, 1, 1),
('Panzarotti Mixto', 'Relleno de queso y jamón', 8000.00, 2, 1, 1),
('Panzarotti Ranchero', 'Relleno de carne y queso', 9000.00, 2, 1, 1),
('Coca Cola 400ml', 'Gaseosa negra', 4000.00, 3, 0, 1),
('Jugo Hit Mora', 'Jugo en caja', 3500.00, 3, 0, 1),
('Brownie con Helado', 'Postre caliente y frío', 7500.00, 4, 0, 1),
('Cerveza Corona', 'Cerveza importada', 8000.00, 3, 0, 1);

-- 4. Producto - Ingrediente
INSERT INTO producto_ingrediente (id_producto, id_ingrediente) VALUES
(1, 1), (1, 2), (1, 8), (1, 9), -- Pepperoni
(2, 1), (2, 3), (2, 4), (2, 8), (2, 9), -- Hawaiana
(3, 1), (3, 5), (3, 6), (3, 8), (3, 9), -- Pollo Champiñones
(4, 1), (4, 3), (4, 9), -- Panzarotti Mixto
(5, 1), (5, 7), (5, 9); -- Panzarotti Ranchero

-- 5. Adiciones
INSERT INTO adicion (nombre, precio, activa_menu) VALUES
('Extra Queso', 3000.00, 1),
('Borde de Queso', 5000.00, 1),
('Salsa BBQ', 1500.00, 1),
('Extra Pepperoni', 4000.00, 1);

-- 6. Combos
INSERT INTO combo (nombre, descripcion, precio_especial, activo_menu) VALUES
('Combo Personal', '1 Panzarotti Mixto + 1 Bebida', 10000.00, 1),
('Combo Pareja', '1 Pizza Hawaiana + 2 Bebidas', 26000.00, 1),
('Combo Familiar', '2 Pizzas + 4 Bebidas + 1 Postre', 65000.00, 1);

-- 7. Combo - Producto
INSERT INTO combo_producto (id_combo, id_producto, cantidad) VALUES
(1, 4, 1), (1, 6, 1), -- Combo personal (Panzarotti + Coca cola)
(2, 2, 1), (2, 6, 2), -- Combo Pareja (Hawaiana + 2 Coca colas)
(3, 1, 1), (3, 3, 1), (3, 6, 4), (3, 8, 1); -- Familiar (Pepperoni + Pollo + 4 Cocas + Brownie)

-- 8. Clientes
INSERT INTO cliente (nombre, telefono, email) VALUES
('Juan Perez', '3001234567', 'juan@mail.com'),
('Ana Gomez', '3109876543', 'ana@mail.com'),
('Carlos Ruiz', '3205554433', 'carlos@mail.com'),
('Maria Lopez', '3156667788', 'maria@mail.com'),
('Pedro Martinez', '3012223344', 'pedro@mail.com');

-- 9. Pedidos (con fechas variadas en el último mes y diferentes días de la semana)
-- Juan Perez tiene > 5 pedidos en el último mes. Tiene pedidos para recoger y local.
INSERT INTO pedido (id_cliente, fecha_hora, tipo_entrega, total) VALUES
(1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Recoger', 30000.00),
(1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Local', 40000.00),
(1, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Recoger', 12000.00),
(1, DATE_SUB(NOW(), INTERVAL 12 DAY), 'Recoger', 25000.00),
(1, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Local', 50000.00),
(1, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Recoger', 15000.00),
(2, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Local', 65000.00),
(3, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Recoger', 28000.00),
(4, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Local', 15000.00),
(5, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Recoger', 35000.00),
(2, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Recoger', 12000.00), -- Ana Gómez también recoger
(3, DATE_SUB(NOW(), INTERVAL 14 DAY), 'Local', 45000.00);  -- Carlos Ruiz local

-- 10. Pedido - Producto (Productos sueltos)
-- Pedido 1: Juan Perez (Recoger, $30000) -> Pizza Hawaiana (22k) + Adicion + Bebida (4k)
INSERT INTO pedido_producto (id_pedido_producto, id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 1, 22000.00), -- Pizza Hawaiana
(2, 1, 6, 1, 4000.00),  -- Coca Cola
-- Pedido 2: Juan Perez (Local, $40000) -> 2 Panzarottis Rancheros (18k) + Adicion + Cerveza (8k) + Postre (7.5k)
(3, 2, 5, 2, 9000.00),
(4, 2, 9, 1, 8000.00),
(5, 2, 8, 1, 7500.00),
-- Pedido 3: Juan Perez (Recoger, $12000) -> 1 Panzarotti Mixto (8k) + Bebida (4k) + extra queso
(6, 3, 4, 1, 8000.00),
(7, 3, 6, 1, 4000.00),
-- Pedido 4: Juan (Recoger, 25k) -> Pizza Pepperoni (25k) SIN ADICIÓN
(8, 4, 1, 1, 25000.00),
-- Pedido 5: Juan (Local, 50k) -> 2 Pizzas Hawaianas (44k) + 1 Coca Cola (4k) + Adición (2k)
(9, 5, 2, 2, 22000.00),
(10, 5, 6, 1, 4000.00),
-- Pedido 8: Carlos (Recoger, 28k) -> Pizza Pollo y Champiñones + Salsa
(11, 8, 3, 1, 26000.00),
-- Pedido 9: Maria (Local, 15k) -> Panzarotti Ranchero + Bebida
(12, 9, 5, 1, 9000.00),
(13, 9, 6, 1, 4000.00);

-- 11. Pedido - Producto - Adición
INSERT INTO pedido_producto_adicion (id_pedido_producto, id_adicion, cantidad, precio_unitario) VALUES
(1, 2, 1, 4000.00), -- Borde de queso a Pizza Hawaiana (Pedido 1)
(3, 1, 2, 3000.00), -- Extra Queso a los 2 Panzarottis Rancheros (Pedido 2)
(6, 1, 1, 3000.00), -- Extra queso a Panzarotti Mixto (Pedido 3)
(9, 4, 1, 4000.00), -- Extra pepperoni a una Pizza Hawaiana (Pedido 5)
(11, 3, 1, 1500.00); -- Salsa BBQ a Pizza de Pollo (Pedido 8)

-- 12. Pedido - Combo
-- Pedido 7: Ana Gomez (Local, $65000) -> 1 Combo Familiar
INSERT INTO pedido_combo (id_pedido, id_combo, cantidad, precio_unitario) VALUES
(7, 3, 1, 65000.00),
-- Pedido 6: Juan (Recoger, $15000) -> 1 Combo Personal + Bebida extra
(6, 1, 1, 10000.00),
-- Pedido 10: Pedro (Recoger, $35000) -> 1 Combo Pareja + 1 Panzarotti Ranchero (9k)
(10, 2, 1, 26000.00),
-- Pedido 11: Ana (Recoger, 12k) -> 1 Combo Personal + salsa
(11, 1, 1, 10000.00),
-- Pedido 12: Carlos (Local, 45k) -> 1 Combo Pareja + Pizza Hawaiana
(12, 2, 1, 26000.00);

-- Añadiendo productos sueltos a pedidos con combo
INSERT INTO pedido_producto (id_pedido_producto, id_pedido, id_producto, cantidad, precio_unitario) VALUES
(14, 6, 6, 1, 4000.00),  -- Bebida extra pedido 6
(15, 10, 5, 1, 9000.00), -- Panzarotti extra pedido 10
(16, 11, 6, 1, 4000.00), -- Bebida extra
(17, 12, 2, 1, 22000.00); -- Pizza extra
