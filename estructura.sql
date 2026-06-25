
CREATE DATABASE IF NOT EXISTS pizzeria_db;
USE pizzeria_db;


CREATE TABLE IF NOT EXISTS categoria_producto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255)
);



CREATE TABLE IF NOT EXISTS producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    elaborado BOOLEAN DEFAULT TRUE, 
    activo_menu BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id_categoria)
);


CREATE TABLE IF NOT EXISTS ingrediente (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS producto_ingrediente (
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    PRIMARY KEY (id_producto, id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id_ingrediente) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS adicion (
    id_adicion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    activa_menu BOOLEAN DEFAULT TRUE
);


CREATE TABLE IF NOT EXISTS combo (
    id_combo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_especial DECIMAL(10, 2) NOT NULL,
    activo_menu BOOLEAN DEFAULT TRUE
);


CREATE TABLE IF NOT EXISTS combo_producto (
    id_combo INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_combo, id_producto),
    FOREIGN KEY (id_combo) REFERENCES combo(id_combo) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100)
);



CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo_entrega ENUM('Recoger', 'Local') NOT NULL,
    total DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);


CREATE TABLE IF NOT EXISTS pedido_producto (
    id_pedido_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);


CREATE TABLE IF NOT EXISTS pedido_producto_adicion (
    id_pedido_producto INT NOT NULL,
    id_adicion INT NOT NULL,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido_producto, id_adicion),
    FOREIGN KEY (id_pedido_producto) REFERENCES pedido_producto(id_pedido_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_adicion) REFERENCES adicion(id_adicion)
);


CREATE TABLE IF NOT EXISTS pedido_combo (
    id_pedido_combo INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_combo INT NOT NULL,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_combo) REFERENCES combo(id_combo)
);
