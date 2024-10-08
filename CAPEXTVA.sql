DROP DATABASE IF EXISTS CAPEXTVA;
CREATE DATABASE CAPEXTVA;
USE CAPEXTVA;

-- Tabla CLIENTE
CREATE TABLE CLIENTE
(
  CLIENTE_ID      INT PRIMARY KEY IDENTITY(1,1),   -- Cambiado de NUMBER a INT
  NOMBRE          VARCHAR(500) NOT NULL, 
  CLAVE           VARCHAR(10) NOT NULL, 
  MAIL            VARCHAR(1000), 
  ESTATUS         VARCHAR(1000)
);

-- Insertar datos en CLIENTE
DECLARE @CLIENTE_ID INT = 1;

WHILE @CLIENTE_ID <= 10
BEGIN
    INSERT INTO CLIENTE (NOMBRE, CLAVE, MAIL, ESTATUS)
    VALUES ('CLIENTE ' + CAST(@CLIENTE_ID AS VARCHAR), 
            'CLIE_' + CAST(@CLIENTE_ID AS VARCHAR), 
            'cliente' + CAST(@CLIENTE_ID AS VARCHAR) + '@clie.com', 
            'ACTIVO');
    SET @CLIENTE_ID = @CLIENTE_ID + 1;
END;

-- Actualizar algunos registros
UPDATE CLIENTE SET ESTATUS = 'INACTIVO' WHERE CLIENTE_ID IN (3, 7, 10);

-- Tabla PRODUCTO
CREATE TABLE PRODUCTO
(
  PRODUCTO_ID     INT PRIMARY KEY IDENTITY(1,1),
  DESCRIPCION     VARCHAR(500) NOT NULL, 
  COSTO_UNITARIO  DECIMAL(10, 2) NOT NULL,  -- Definir precisión para costos
  ESTATUS         VARCHAR(1000)
);

-- Insertar datos en PRODUCTO
DECLARE @PRODUCTO_ID INT = 1;

WHILE @PRODUCTO_ID <= 15
BEGIN
    INSERT INTO PRODUCTO ( DESCRIPCION, COSTO_UNITARIO, ESTATUS)
    VALUES ('PRODUCTO ' + CAST(@PRODUCTO_ID AS VARCHAR),
            ROUND(RAND() * (9999 - 1) + 1, 2), 
            'ACTIVO');
    SET @PRODUCTO_ID = @PRODUCTO_ID + 1;
END;

-- Actualizar algunos registros
UPDATE PRODUCTO SET ESTATUS = 'INACTIVO' WHERE PRODUCTO_ID IN (5, 11, 13);

-- Tabla VENTA
CREATE TABLE VENTA
(
  VENTA_ID        INT PRIMARY KEY IDENTITY(1,1),
  FECHA           DATE NOT NULL, 
  CLIENTE_ID      INT NOT NULL, 
  ESTATUS         VARCHAR(100),
  CONSTRAINT FK_CLIENTE FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (CLIENTE_ID)
);

-- Tabla DETALLE_VENTA
CREATE TABLE DETALLE_VENTA
(
  VENTA_ID        INT NOT NULL, 
  PRODUCTO_ID     INT NOT NULL, 
  CANTIDAD        INT NOT NULL, 
  DESCUENTO       DECIMAL(10, 2), 
  TOTAL           DECIMAL(10, 2) NOT NULL, 
  PRIMARY KEY (VENTA_ID, PRODUCTO_ID), 
  CONSTRAINT FK_VENTA FOREIGN KEY (VENTA_ID) REFERENCES VENTA (VENTA_ID),
  CONSTRAINT FK_PRODUCTO FOREIGN KEY (PRODUCTO_ID) REFERENCES PRODUCTO (PRODUCTO_ID)
);

CREATE VIEW VISTA_VENTAS_CLIENTES AS
SELECT
	V.VENTA_ID AS ID,
    C.CLAVE AS Clave_Cliente,
    C.NOMBRE AS Cliente,
    C.MAIL AS Mail,
    V.FECHA AS Fecha,
	P.DESCRIPCION AS Producto,
	P.COSTO_UNITARIO AS Precio,
	DV.CANTIDAD AS Cantidad,
    DV.TOTAL AS Total
FROM
    CLIENTE C
INNER JOIN
    VENTA V ON C.CLIENTE_ID = V.CLIENTE_ID
INNER JOIN
    DETALLE_VENTA DV ON V.VENTA_ID = DV.VENTA_ID
INNER JOIN
    PRODUCTO P ON DV.PRODUCTO_ID = P.PRODUCTO_ID
GROUP BY
    V.VENTA_ID, C.CLAVE, C.NOMBRE, C.MAIL, V.FECHA, P.DESCRIPCION, P.COSTO_UNITARIO, DV.CANTIDAD, DV.TOTAL;
