-- 1. CREAR BASE DE DATOS

CREATE DATABASE mercado_tradicional1;
USE mercado_tradicional1;

-- 2. CATEGORÍAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE
);

-- 3. PUESTOS
CREATE TABLE puestos (
    id_puesto INT AUTO_INCREMENT PRIMARY KEY,
    numero_puesto VARCHAR(10) NOT NULL UNIQUE,
    seccion VARCHAR(50) NOT NULL
);

-- 4. PROVEEDORES
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    ruc_dni VARCHAR(20) UNIQUE
);

-- 5. COMERCIANTES (CORREGIDO: se quitó UNIQUE)
CREATE TABLE comerciantes (
    id_comerciante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    id_puesto INT,
    CONSTRAINT fk_puesto FOREIGN KEY (id_puesto) 
        REFERENCES puestos(id_puesto) ON DELETE SET NULL
);

-- 6. PRODUCTOS (dejamos tu diseño original)
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

-- 7. CLIENTES
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    dni_cliente VARCHAR(20) UNIQUE
);

-- 8. FACTURA (ENCABEZADO)
CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT,
    id_puesto INT,
    total_venta DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_factura_puesto FOREIGN KEY (id_puesto) 
        REFERENCES puestos(id_puesto)
);

-- 9. DETALLE FACTURA
CREATE TABLE detalle_factura (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_factura FOREIGN KEY (id_factura) 
        REFERENCES facturas(id_factura) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto)
);

-- ------------------------------------------------------------
-- INSERTAR DATOS
-- ------------------------------------------------------------

-- CATEGORIAS
INSERT INTO categorias (nombre_categoria)
VALUES ('Carnes'), ('Lacteos'), ('Verduras'), ('Frutas'), ('Avicola'),
('Sin Categoria'), ('Bebidas'), ('Comida'), ('Granos'), ('Dulces');

-- PUESTOS
INSERT INTO puestos (numero_puesto, seccion) VALUES 
('A-01', 'Norte'), ('A-02', 'Norte'), ('B-01', 'Sur'), ('B-02', 'Sur'), 
('C-01', 'Este'), ('C-02', 'Este'), ('D-01', 'Oeste'), ('D-02', 'Oeste'), 
('E-01', 'Central'), ('E-02', 'Central');

-- PROVEEDORES
INSERT INTO proveedores (nombre_empresa,telefono,ruc_dni)
VALUES 
('Girazioles S.A','24267154','1563204785'),
('Rosales S.A','378921','1450136974'),
('Healthy Food','8956748','3512048976'),
('Provefrut','8745263','784963012589'),
('Grupo Avicola La Pradera','3526874','7481036954'),
('Avirico Cía. Ltda.','5478963','7415287469'),
('Mangosa','7895631','45896321584'),
('Café Vélez','1024513','632589748563'),
('Nescafé','6325418','74856321053'),
('Food','5689748','24896357812');

-- CLIENTES
INSERT INTO clientes (nombre_cliente, dni_cliente) VALUES 
('Juan Pérez', '11111111'), ('María García', '22222222'), 
('Carlos Ruiz', '33333333'), ('Ana López', '44444444'), 
('Luis Torres', '55555555'), ('Elena Rivas', '66666666'), 
('Pedro Sosa', '77777777'), ('Sofía Méndez', '88888888'), 
('Jorge Luna', '99999999'), ('Lucía Prado', '10101010');

-- COMERCIANTES
INSERT INTO comerciantes (nombre, dni, id_puesto) VALUES 
('Roberto Díaz', '12345671', 1), ('Marta Solis', '12345672', 2), 
('Ricardo Paz', '12345673', 3), ('Julia Vega', '12345674', 4), 
('Oscar Ríos', '12345675', 5), ('Rosa Lima', '12345676', 6), 
('Hugo Castro', '12345677', 7), ('Inés Duarte', '12345678', 8), 
('Felipe Sanz', '12345679', 9), ('Silvia Mora', '12345680', 10);

-- PRODUCTOS
INSERT INTO productos (nombre_producto, precio_unitario, stock_actual, id_categoria, id_proveedor, id_comerciante) VALUES 
('Manzanas Gala', 2.50, 100, 4, 2, 1),
('Leche Entera', 3.20, 50, 2, 3, 2),
('Arroz Extra', 4.50, 200, 9, 5, 3),
('Detergente 1kg', 8.90, 30, 6, 6, 4),
('Pollo Entero', 15.00, 20, 5, 4, 5),
('Pan de Molde', 5.50, 15, 8, 7, 6),
('Agua Mineral', 1.50, 80, 7, 8, 7),
('Papas Fritas', 2.00, 60, 10, 9, 8),
('Shampoo Anticaspa', 12.00, 25, 6, 10, 9),
('Zanahorias', 1.20, 120, 3, 2, 10);

-- FACTURAS (IDs correctos)
INSERT INTO facturas (id_cliente, id_puesto, fecha_emision, total_venta) VALUES 
(1, 2, '2025-12-05', 25.00),
(2, 2, '2025-12-05', 15.50),
(3, 3, '2025-10-05', 45.00),
(4, 4, '2025-09-25', 8.90),
(5, 5, '2025-11-15', 30.00),
(6, 6, '2025-11-18', 11.00),
(7, 7, '2025-08-25', 4.50),
(8, 8, '2025-12-25', 6.00),
(9, 9, '2026-01-05', 24.00),
(10,10,'2026-01-05', 12.00);

-- DETALLE FACTURA (IDs corregidos)
INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_venta) VALUES 
(1,1,10,2.50), (1,2,5,3.20),
(2,3,10,4.50),
(3,4,1,8.90),
(4,5,2,15.00),
(5,6,2,5.50),
(6,7,3,1.50),
(7,8,3,2.00),
(8,9,2,12.00),
(9,10,10,1.20);

select*from categorias;
select*from puestos;
select*from proveedores;
select*from comerciantes;
select*from productos;
select*from clientes;
select*from facturas;
select * from detalle_factura;

-- CONSULTAS BÁSICAS ############################################################
-- Buscar cliente por ID
SELECT nombre_cliente AS Nombre
FROM clientes
WHERE id_cliente = 7;

-- Buscar puesto por ID
SELECT numero_puesto, seccion
FROM puestos
WHERE id_puesto = 5;

-- Productos con mayor stock
SELECT nombre_producto, precio_unitario, stock_actual
FROM productos
WHERE stock_actual > 50;

-- Contar cuántos clientes existen
SELECT COUNT(*) AS TotalClientes
FROM clientes;

-- Promedio de ventas
SELECT AVG(total_venta) AS PromedioVentas
FROM facturas;

-- Número de comerciantes
SELECT COUNT(*) AS TotalComerciantes
FROM comerciantes;

-- Mostrar productos ordenados por precio
SELECT *
FROM productos
ORDER BY precio_unitario DESC;

-- Buscar clientes cuyo nombre contiene la letra G
SELECT *
FROM clientes 
WHERE nombre_cliente LIKE '%G%';

-- Buscar puestos por sección
SELECT *
FROM puestos
WHERE seccion IN ('Norte', 'Sur');

-- JOINS ###################################################################
-- 1) Categoría + proveedor + producto
SELECT 
    p.nombre_producto,
    c.nombre_categoria,
    prov.nombre_empresa AS proveedor
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
JOIN proveedores prov ON p.id_proveedor = prov.id_proveedor;

-- 2) Ubicación del puesto de cada comerciante
SELECT 
    c.nombre AS comerciante,
    p.numero_puesto,
    p.seccion
FROM comerciantes c
JOIN puestos p ON c.id_puesto = p.id_puesto;

-- 3) Detalle de venta por factura
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

-- 4) Total de productos vendidos por categoría
SELECT 
    cat.nombre_categoria,
    SUM(df.cantidad) AS total_unidades_vendidas
FROM detalle_factura df
JOIN productos p ON df.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
GROUP BY cat.nombre_categoria;

-- 5) Ubicación de cada producto en el mercado
SELECT 
    p.nombre_producto,
    c.nombre AS comerciante,
    pst.numero_puesto,
    pst.seccion
FROM productos p
JOIN comerciantes c ON p.id_comerciante = c.id_comerciante
JOIN puestos pst ON c.id_puesto = pst.id_puesto;

-- 6) Historial de compras por cliente
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

-- CONSULTAS CON AGREGACIONES ######################################################
-- Estadísticas de inventario
SELECT 
    COUNT(*) AS total_productos,
    SUM(stock_actual) AS unidades_totales,
    AVG(precio_unitario) AS precio_promedio,
    MAX(precio_unitario) AS precio_maximo
FROM productos;

-- Ventas totales por cliente
SELECT 
    c.nombre_cliente,
    SUM(f.total_venta) AS total_gastado
FROM clientes c
JOIN facturas f ON c.id_cliente = f.id_cliente
GROUP BY c.nombre_cliente;

-- Inventario por categoría
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


-- FUNCIONES DE CADENA ########################################################
-- Formatear nombres de clientes
SELECT 
    CONCAT(
        UPPER(LEFT(nombre_cliente, 1)),
        LOWER(SUBSTRING(nombre_cliente, 2))
    ) AS nombre_formateado
FROM clientes;

-- Producto con precio formateado
SELECT 
    UPPER(nombre_producto) AS PRODUCTO,
    CONCAT('$ ', precio_unitario) AS PRECIO_FORMATADO
FROM productos;

-- Agregar IVA del 15%
SELECT 
    nombre_producto,
    precio_unitario AS precio_base,
    (precio_unitario * 0.15) AS monto_iva,
    (precio_unitario * 1.15) AS precio_con_iva
FROM productos;

-- SUBCONSULTAS #######################################################################
-- Productos con precio mayor al promedio
SELECT nombre_producto, precio_unitario
FROM productos
WHERE precio_unitario > (SELECT AVG(precio_unitario) FROM productos);

-- Buscar productos por categoría "Frutas" o "Verduras"
SELECT nombre_producto
FROM productos
WHERE id_categoria IN (
    SELECT id_categoria
    FROM categorias
    WHERE nombre_categoria LIKE '%Fruta%' OR nombre_categoria LIKE '%Verdura%'
);

-- Unidades vendidas por producto
SELECT 
    p.nombre_producto,
    (SELECT SUM(cantidad) 
     FROM detalle_factura 
     WHERE id_producto = p.id_producto) AS unidades_vendidas
FROM productos p;

-- Proveedores sin productos asociados
SELECT nombre_empresa
FROM proveedores prov
WHERE NOT EXISTS (
    SELECT 1 FROM productos p 
    WHERE p.id_proveedor = prov.id_proveedor
);


-- VISTAS ####################################################################
-- Productos a punto de acabarse
CREATE VIEW vista_alerta_stock AS
SELECT 
    p.nombre_producto,
    p.stock_actual,
    prov.nombre_empresa AS proveedor,
    prov.telefono AS contacto_proveedor
FROM productos p
JOIN proveedores prov ON p.id_proveedor = prov.id_proveedor
WHERE p.stock_actual < 2;
drop view vista_alerta_stock;
select*from vista_alerta_stock;

-- Vista detallada de la facturación completa
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

SELECT*from vistaFacturacion;

-- insert, update y delete ###################################################
-- INSERTAR NUEVOS PRODUCTOS
INSERT INTO productos (nombre_producto, precio_unitario, stock_actual, id_categoria) 
VALUES 
('Naranjas Huando', 3.50, 200, 4),
('Yogurt Natural', 5.20, 40, 2),
('Detergente Pro', 12.00, 15, 6);

-- Insertar cliente solo si no existe
INSERT INTO clientes (nombre_cliente, dni_cliente)
SELECT 'Nuevo Cliente Especial', '99887766'
WHERE NOT EXISTS (
    SELECT 1 FROM clientes WHERE dni_cliente = '99887766'
);

-- UPDATE: aumentar stock
UPDATE productos
SET stock_actual = stock_actual + 50
WHERE nombre_producto = 'Arroz Extra';

-- UPDATE: cambiar comerciante de puesto
UPDATE comerciantes
SET id_puesto = 7
WHERE id_comerciante = 2;

-- DELETE: eliminar producto por ID
DELETE FROM productos
WHERE id_producto = 10;

-- DELETE: eliminar clientes sin DNI
DELETE FROM clientes
WHERE dni_cliente IS NULL;

-- DELETE: eliminar facturas antiguas
DELETE FROM detalle_factura
WHERE id_factura IN (
    SELECT id_factura FROM facturas WHERE fecha_emision < '2023-01-01'
);

CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'Admin123';
GRANT ALL PRIVILEGES ON mercado_tradicional1.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;

CREATE USER IF NOT EXISTS 'encargado_puesto'@'%' IDENTIFIED BY 'Encargado123';

GRANT SELECT, INSERT, UPDATE ON mercado_tradicional1.productos TO 'encargado_puesto'@'localhost';
GRANT SELECT ON mercado_tradicional1.categorias TO 'encargado_puesto'@'localhost';
GRANT SELECT ON mercado_tradicional1.proveedores TO 'encargado_puesto'@'localhost';
GRANT SELECT ON mercado_tradicional1.comerciantes TO 'encargado_puesto'@'localhost';
GRANT SELECT, INSERT, UPDATE ON mercado_tradicional1.facturas TO 'encargado_puesto'@'localhost';
GRANT SELECT, INSERT ON mercado_tradicional1.detalle_factura TO 'encargado_puesto'@'localhost';
flush PRIVILEGES;

CREATE USER IF NOT EXISTS 'cliente'@'localhost' IDENTIFIED BY 'Cliente123';

GRANT SELECT ON mercado_tradicional1.productos TO 'cliente'@'localhost';
GRANT SELECT ON mercado_tradicional1.categorias TO 'cliente'@'localhost';
GRANT SELECT ON mercado_tradicional1.proveedores TO 'cliente'@'localhost';

FLUSH PRIVILEGES;

-- para revocar permisos si aplica
REVOKE UPDATE ON mercado_tradicional1.productos FROM 'encargado_puesto'@'%';

-- TRIGGER DE AUDITORIA ###############
CREATE TABLE auditoria_inventario (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabla_modificada VARCHAR(50),
    accion VARCHAR(20),
    id_registro INT,
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_responsable VARCHAR(50)
);

-- TRIGGER DE AUDITORIA DE INSERT #########################################
DELIMITER $$

CREATE TRIGGER tg_productos_insert
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_inventario(tabla_modificada, accion, id_registro, descripcion, usuario_responsable)
    VALUES ('productos', 'INSERT', NEW.id_producto,
            CONCAT('Producto insertado: ', NEW.nombre_producto),
            CURRENT_USER());
END $$

DELIMITER ;

-- TRIGGER DE AUDITORIA DE UPDATE #########################################
DELIMITER $$

CREATE TRIGGER tg_productos_update
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_inventario(tabla_modificada, accion, id_registro, descripcion, usuario_responsable)
    VALUES ('productos', 'UPDATE', NEW.id_producto,
            CONCAT('Stock antes: ', OLD.stock_actual, ' | Stock después: ', NEW.stock_actual),
            CURRENT_USER());
END $$

DELIMITER ;

-- TRIGGER DE AUDITORIA DE delete #########################################
DELIMITER $$

CREATE TRIGGER tg_productos_delete
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_inventario(tabla_modificada, accion, id_registro, descripcion, usuario_responsable)
    VALUES ('productos', 'DELETE', OLD.id_producto,
            CONCAT('Producto eliminado: ', OLD.nombre_producto),
            CURRENT_USER());
END $$

DELIMITER ;

-- Full backup
mysqldump -u root -p mercado_tradicional1 > backup_completo.sql;

-- backup incremental
SELECT *
FROM facturas
WHERE fecha_emision >= DATE_SUB(NOW(), INTERVAL 7 DAY)
INTO OUTFILE '/tmp/backup_incremental_facturas.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
