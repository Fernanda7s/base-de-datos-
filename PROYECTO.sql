-- 1. Creación de la Base de Datos
CREATE DATABASE IF NOT EXISTS mercado_tradicional1;
USE mercado_tradicional1;

-- 2. Tabla de Categorías
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE
);
select*from categorias;
-- 3. Tabla de Puestos
CREATE TABLE puestos (
    id_puesto INT AUTO_INCREMENT PRIMARY KEY,
    numero_puesto VARCHAR(10) NOT NULL UNIQUE,
    seccion VARCHAR(50) NOT NULL
);
select*from puestos;
-- 4. Tabla de Proveedores
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    ruc_dni VARCHAR(20) UNIQUE
);
select*from proveedores;
-- 5. Tabla de Comerciantes
CREATE TABLE comerciantes (
    id_comerciante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    id_puesto INT UNIQUE,
    CONSTRAINT fk_puesto FOREIGN KEY (id_puesto) 
        REFERENCES puestos(id_puesto) ON DELETE SET NULL
);
select*from comerciantes;
-- 6. Tabla de Productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    id_categoria INT,
    id_proveedor INT,
    id_comerciante INT,
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) 
        REFERENCES categorias(id_categoria),
    CONSTRAINT fk_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_comerciante FOREIGN KEY (id_comerciante) 
        REFERENCES comerciantes(id_comerciante) ON DELETE CASCADE
);
select*from productos;
-- 7. Tabla de Clientes (NUEVA)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    dni_cliente VARCHAR(20) UNIQUE
);
select*from clientes;
-- 8. Tabla de Facturas (NUEVA - Encabezado)
CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT,
    id_puesto INT, -- Para saber de qué puesto salió la venta
    total_venta DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_factura_puesto FOREIGN KEY (id_puesto) 
        REFERENCES puestos(id_puesto)
);
select*from facturas;
-- 9. Tabla de Detalle_Factura (NUEVA - Para cumplir 3FN)
-- Permite vender múltiples productos en una sola factura
CREATE TABLE detalle_factura (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL, -- Se guarda el precio del momento
    CONSTRAINT fk_detalle_factura FOREIGN KEY (id_factura) 
        REFERENCES facturas(id_factura) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto)
);
select * from detalle_factura;

-- --- DATOS DE PRUEBA ACTUALIZADOS ---
INSERT INTO clientes (nombre_cliente, dni_cliente) VALUES ('Ana Garcia', '12345678');

-- Ejemplo de una factura para el puesto 1 (donde atiende Juan Pérez)
INSERT INTO facturas (id_cliente, id_puesto, total_venta) VALUES (1, 1, 5.00);

-- Ejemplo de productos en esa factura
INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_venta) VALUES (1, 1, 10, 0.50);
-- __________________________________________________________________________________________________________________________________________________
insert into categorias (nombre_categoria)
values ("Carnes "),("Lacteos"),("Verduras"),("Frutas"),("Avicola"),("Sin Categoria"),("Bebidas"),("Comida"),("Granos"),("Dulces");

INSERT INTO puestos (numero_puesto, seccion) VALUES 
('A-01', 'Norte'), ('A-02', 'Norte'), ('B-01', 'Sur'), ('B-02', 'Sur'), 
('C-01', 'Este'), ('C-02', 'Este'), ('D-01', 'Oeste'), ('D-02', 'Oeste'), 
('E-01', 'Central'), ('E-02', 'Central');

insert into proveedores (nombre_empresa,telefono,ruc_dni)
values ("Girazioles S.A","24267154","1563204785"),
("Rosales S.A","378921","1450136974"),
("Healthy Food","8956748","3512048976"),
("Provefrut:","8745263","784963012589"),
("Grupo Avicola La Pradera","3526874","7481036954"),
("Avirico Cía. Ltda.","5478963","7415287469"),
("Mangosa","7895631","45896321584"),
("Café Vélez","1024513","632589748563"),
("Nescafé","6325418","74856321053"),
("Food","5689748","24896357812");


INSERT INTO clientes (nombre_cliente, dni_cliente) VALUES 
('Juan Pérez', '11111111'), ('María García', '22222222'), 
('Carlos Ruiz', '33333333'), ('Ana López', '44444444'), 
('Luis Torres', '55555555'), ('Elena Rivas', '66666666'), 
('Pedro Sosa', '77777777'), ('Sofía Méndez', '88888888'), 
('Jorge Luna', '99999999'), ('Lucía Prado', '10101010');

INSERT INTO comerciantes (nombre, dni, id_puesto) VALUES 
('Roberto Díaz', '12345671', 1), ('Marta Solis', '12345672', 2), 
('Ricardo Paz', '12345673', 3), ('Julia Vega', '12345674', 4), 
('Oscar Ríos', '12345675', 5), ('Rosa Lima', '12345676', 6), 
('Hugo Castro', '12345677', 7), ('Inés Duarte', '12345678', 8), 
('Felipe Sanz', '12345679', 9), ('Silvia Mora', '12345680', 10);

INSERT INTO productos (nombre_producto, precio_unitario, stock_actual, id_categoria, id_proveedor, id_comerciante) VALUES 
('Manzanas Gala', 2.50, 100, 1, 2, 1),
('Leche Entera', 3.20, 50, 3, 3, 2),
('Arroz Extra', 4.50, 200, 5, 5, 3),
('Detergente 1kg', 8.90, 30, 6, 6, 4),
('Pollo Entero', 15.00, 20, 4, 4, 5),
('Pan de Molde', 5.50, 15, 7, 7, 6),
('Agua Mineral', 1.50, 80, 8, 8, 7),
('Papas Fritas', 2.00, 60, 9, 9, 8),
('Shampoo Anticaspa', 12.00, 25, 10, 10, 9),
('Zanahorias', 1.20, 120, 2, 2, 10);

INSERT INTO facturas (fecha_emision,id_cliente, id_puesto, total_venta) VALUES 
('2025-12-5', 1,2, 25.00), ('2025-12-5',2, 2, 15.50), ('2025-10-5',3, 3, 45.00), ('2025-9-25',4, 4, 8.90), 
('2025-11-15',5, 5, 30.00), ('2025-11-18',6, 6, 11.00), ('2025-8-25',7, 7, 4.50), ('2025-12-25',8, 8, 6.00), 
('2026-1-5',9, 9, 24.00), ('2026-1-5',10, 10, 12.00);

INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_venta) VALUES 
( 32,1, 10, 2.50), ( 32,2, 5, 3.10), ( 32,3, 10, 4.50), (39,4, 1, 8.90), 
(33,5, 2, 15.00), ( 35, 6,2, 5.50), ( 37,7, 3, 1.50), ( 41,8, 3, 2.00), 
(34,9, 2, 12.00), (39,10, 10, 1.20);


select*from categorias;
select*from puestos;
select*from proveedores;
select*from comerciantes;
select*from productos;
select*from clientes;
select*from facturas;
select * from detalle_factura;

 -- Diseña al menos 10 consultas SQL que respondan a necesidades del sistema:
 -- • Selecciones simples y con condiciones. 
 
 -- buscar cliente 
 select nombre_cliente as Nombre
 from clientes
 where id_cliente=7;
 -- buscar puesto 
 select numero_puesto , seccion as CodigoPuesto
 from puestos
 where id_puesto=5;
 -- buscar prodcutos con mayor stock 
  select nombre_producto ,precio_unitario,stock_actual
 from productos
 where stock_actual>50;
 -- contar cuantos clientes
select count(nombre_producto) as Cliente
 from productos;
 
 -- pormedio de ventas
 select avg(total_venta) as Pormedio
 from facturas;
 
 -- numero de comerciantes 
 select count(nombre) as Cliente
 from comerciantes;
 -- mostrar facturas 
 
 -- mostrar por el precio entre 
 selec
 from productos;
 
 SELECT * FROM clientes 
WHERE nombre_cliente LIKE '%G%';
 -- buscar puestos
 SELECT * FROM puestos 
WHERE seccion = 'Norte' OR seccion = 'Sur';
 
 -- • 6 Joins entre múltiples tablas. __________________________________________
 -- categoria proveedor
 SELECT 
    p.nombre_producto, 
    c.nombre_categoria, 
    prov.nombre_empresa AS proveedor
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
JOIN proveedores prov ON p.id_proveedor = prov.id_proveedor; 

-- ubicacion de puestos
SELECT 
    c.nombre AS comerciante, 
    p.numero_puesto, 
    p.seccion
FROM comerciantes c
JOIN puestos p ON c.id_puesto = p.id_puesto; 
-- ventta por factura
SELECT 
    f.id_factura, 
    cl.nombre_cliente, 
    prod.nombre_producto, 
    df.cantidad, 
    df.precio_venta
FROM facturas f
JOIN clientes cl ON f.id_cliente = cl.id_cliente
JOIN detalle_factura df ON f.id_factura = df.id_factura
JOIN productos prod ON df.id_producto = prod.id_producto;

-- porductos vendidos 
SELECT 
    cat.nombre_categoria, 
    SUM(df.cantidad) AS total_unidades_vendidas
FROM detalle_factura df
JOIN productos p ON df.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
GROUP BY cat.nombre_categoria;
-- ubicaion de cada producto
SELECT 
    p.nombre_producto, 
    c.nombre AS dueño_puesto, 
    pst.numero_puesto, 
    pst.seccion
FROM productos p
JOIN comerciantes c ON p.id_comerciante = c.id_comerciante
JOIN puestos pst ON c.id_puesto = pst.id_puesto;

-- historial de compras
SELECT 
    cl.nombre_cliente, 
    f.fecha_emision, 
    p.nombre_producto, 
    df.cantidad, 
    (df.cantidad * df.precio_venta) AS subtotal
FROM clientes cl
JOIN facturas f ON cl.id_cliente = f.id_cliente
JOIN detalle_factura df ON f.id_factura = df.id_factura
JOIN productos p ON df.id_producto = p.id_producto
WHERE cl.nombre_cliente = 'Juan Pérez';

-- AGREGACIONES 
-- ESTADITICAS INVENTARIO
SELECT 
    COUNT(*) AS total_productos,
    SUM(stock_actual) AS unidades_totales,
    AVG(precio_unitario) AS precio_promedio,
    MAX(precio_unitario) AS precio_maximo
FROM productos; 
-- VENTAS POR CLIENTE
SELECT 
    c.nombre_cliente, 
    SUM(f.total_venta) AS total_gastado
FROM clientes c
JOIN facturas f ON c.id_cliente = f.id_cliente
GROUP BY c.nombre_cliente; 

-- INVENTARIO DE CATEGORIA
SELECT 
    c.nombre_categoria AS Categoria,
    COUNT(p.id_producto) AS Variedad_Productos,
    SUM(p.stock_actual) AS Unidades_Totales,
    SUM(p.stock_actual * p.precio_unitario) AS Valor_Invertido,
    MAX(p.precio_unitario) AS Precio_Maximo
FROM categorias c
LEFT JOIN productos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY Valor_Invertido DESC; 
-- FUNCIONES EN CADENA 
//DELIMITER 
SELECT 
    CONCAT(
        UPPER(LEFT(nombre_cliente, 1)), -- Primera letra en Mayúscula
        LOWER(SUBSTRING(nombre_cliente, 2)) -- El resto en minúscula
    ) AS nombre_formateado
FROM clientes; 
-- Funciones de cadena. • Subconsultas y vistas. • 
SELECT 
    UPPER(nombre_producto) AS PRODUCTO,
    CONCAT('S/ ', precio_unitario) AS PRECIO_FORMATO
FROM productos; 

-- FUNCIONES PARA AGREGAR IVA SELECT 
SELECT 
    nombre_producto, 
    precio_unitario AS precio_base,
    (precio_unitario * 0.15) AS monto_iva,
    (precio_unitario * 1.15) AS precio_con_iva
FROM productos;

-- SUBCONSULTAS ____________________________________________________________________
-- PRODUCTOS MAYOR AL PORMEDIO 

SELECT nombre_producto, precio_unitario
FROM productos
WHERE precio_unitario > (SELECT AVG(precio_unitario) FROM productos);
 Incluye ejemplos de actualización, eliminación e inserción de datos.
 
 -- BUSCAR POR CATEGORIAS UN PRODCUTO
 SELECT nombre_producto 
FROM productos 
WHERE id_categoria IN (
    SELECT id_categoria 
    FROM categorias 
    WHERE nombre_categoria LIKE '%Fruta%' OR nombre_categoria LIKE '%Verdura%'
);

-- PARA VER LAS UNIDADES MAS VENDIDAS 
SELECT 
    nombre_producto,
    (SELECT SUM(cantidad) 
     FROM detalle_factura 
     WHERE id_producto = p.id_producto) AS unidades_vendidas
FROM productos p;

-- PORVEEDORES INECESARIOS 
SELECT nombre_empresa
FROM proveedores prov
WHERE NOT EXISTS (
    SELECT 1 
    FROM productos p 
    WHERE p.id_proveedor = prov.id_proveedor
);


-- VISTAS___________________________________________________
-- los prodcutos que estan apunto de terminar 
CREATE VIEW vista_alerta_stock AS
SELECT 
    p.nombre_producto,
    p.stock_actual,
    prov.nombre_empresa AS proveedor,
    prov.telefono AS contacto_proveedor
FROM productos p
JOIN proveedores prov ON p.id_proveedor = prov.id_proveedor
WHERE p.stock_actual < 10;


-- vista de la factura completa 
CREATE VIEW vistaFacturacion AS
SELECT 
    f.id_factura,
    f.fecha_emision,
    cl.nombre_cliente,
    p.nombre_producto,
    df.cantidad,
    df.precio_venta,
    (df.cantidad * df.precio_venta) AS subtotal
FROM facturas f
JOIN clientes cl ON f.id_cliente = cl.id_cliente
JOIN detalle_factura df ON f.id_factura = df.id_factura
JOIN productos p ON df.id_producto = p.id_producto;


-- INSERT______________________________________________________________
-- Inserción nuevos productos
INSERT INTO productos (nombre_producto, precio_unitario, stock_actual, id_categoria) 
VALUES 
('Naranjas Huando', 3.50, 200, 1),
('Yogurt Natural', 5.20, 40, 3),
('Detergente Pro', 12.00, 15, 6);

-- Insertar un cliente nuevo solo si no existe 
INSERT INTO clientes (nombre_cliente, dni_cliente)
SELECT 'Nuevo Cliente Especial', '99887766'
WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE dni_cliente = '99887766');
-- UPDATE______________________________________________________________
-- aCTUALIZAR STOCK 
UPDATE productos 
SET stock_actual = stock_actual + 50 
WHERE nombre_producto = 'Arroz Extra';

-- Cambiar a un comerciante de puesto
UPDATE comerciantes 
SET id_puesto = 7
WHERE id_comerciante = 2;
-- DELETE______________________________________________________________
-- Eliminar un producto específico por su ID
DELETE FROM productos 
WHERE id_producto = 10;

-- Eliminar clientes que no tienen DNI registrado 
DELETE FROM clientes 
WHERE dni_cliente IS NULL;

-- ELIMINA REGISTROS ANTIGUOS
DELETE FROM detalle_factura 
WHERE id_factura IN (SELECT id_factura FROM facturas WHERE fecha_emision < '2023-01-01');