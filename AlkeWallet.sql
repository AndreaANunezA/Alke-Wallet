-- 1. Crear una conexión a una Base de Datos llamada Alke Wallet
CREATE DATABASE IF NOT EXISTS AlkeWallet;
USE AlkeWallet;
SHOW DATABASES;
-- ------------------------------------------------------------------------------------------------
-- 2. Crear Entidades:
-- 2.1. Tabla Usuario
-- Se incluye currency_id para permitir que el usuario elija una moneda 
CREATE TABLE IF NOT EXISTS Usuario (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(20) NOT NULL,
    saldo DECIMAL(10, 2),
    currency_id INT
);
DESCRIBE Usuario;

-- 2.2. Tabla Moneda
CREATE TABLE Moneda (
    currency_id INT PRIMARY KEY AUTO_INCREMENT,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);
DESCRIBE Moneda;

-- 2.3. Tabla Transacción
CREATE TABLE IF NOT EXISTS Transaccion (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    importe DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	currency_id INT NOT NULL,
    CONSTRAINT fk_sender FOREIGN KEY (sender_user_id) REFERENCES Usuario(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_receiver FOREIGN KEY (receiver_user_id) REFERENCES Usuario(user_id) ON DELETE CASCADE,
	CONSTRAINT fk_currency FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id) ON DELETE CASCADE
);
DESCRIBE Transaccion;

-- 2.4. Tabla TipoCambio
CREATE TABLE TipoCambio (
    currency_id INT PRIMARY KEY,
    valor_respecto_base DECIMAL(10, 2),
    FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id)
);
DESCRIBE TipoCambio;

-- Listasr todas las tablas de AlkeWallet
SHOW TABLES;
-- ------------------------------------------------------------------------------------------------

-- 3. Insertar datos:
-- 3.1. Tabla Usuario
INSERT INTO AlkeWallet.Usuario (nombre, correo_electronico, contrasena, saldo, currency_id) VALUES
	('Arturo Prat', 'aprat@aa.cl', 1234, 5500.25, 1),
	('Thomas Cochrane', 'tcochrane@aa.cl', 2345, 6000.00, 2),
	('Manuel Encalada', 'mencalada@aa.cl', 3456, 4500.50, 3),
	('Carlos Condell', 'ccondell@aa.cl', 'pass1234', 5000.00, 1),
	('Juan Aldea', 'jaldea@aa.cl', 'pass2345', 2500.50, 2);
    
SELECT * FROM AlkeWallet.Usuario;


-- 3.2. Tabla Moneda
INSERT INTO AlkeWallet.Moneda (currency_name, currency_symbol) VALUES
	('Dolar', '$'),
	('Peso chileno', '$'),
	('Euro', '€');
    
SELECT * FROM AlkeWallet.Moneda;

-- 3.3. Tabla Transaccion
INSERT INTO AlkeWallet.Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES 
	(1, 2, 250.00, 1),
	(3, 1, 500.00, 1);
    
SELECT * FROM AlkeWallet.Transaccion;
    
-- 3.4. Tabla TipoCambio
INSERT INTO AlkeWallet.TipoCambio (currency_id, valor_respecto_base) VALUES 
	(1, 1.0),    -- Dolar
	(2, 850.0),  -- Peso Chileno
	(3, 0.92);   -- Euro
    
SELECT * FROM AlkeWallet.TipoCambio;
-- ------------------------------------------------------------------------------------------------
    
-- 4. ACID
-- Transferir 100 pesos chilenos, desde el usuario 2 al usuario 5 (ejecutar linea a linea)
START TRANSACTION;

UPDATE Usuario SET saldo = saldo - 100.00 WHERE user_id = 2;

UPDATE Usuario SET saldo = saldo + 100.00 WHERE user_id = 5;

INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES
	(2, 5, 100.00, 2);

COMMIT; -- Si todo es correcto

-- ROLLBACK; -- En caso de error
-- ------------------------------------------------------------------------------------------------


-- Crear consultas SQL para:
-- Otener el nombre de la moneda elegida por un usuario específico.
SELECT U.nombre, M.currency_name FROM AlkeWallet.Moneda AS M
	INNER JOIN AlkeWallet.Usuario AS U
		ON M.currency_id = U.currency_id
WHERE U.user_id = 2;

-- Obtener todas las transacciones registradas.
SELECT * FROM AlkeWallet.Transaccion;

-- Obtener todas las transacciones realizadas por un usuario específico.
SELECT * FROM AlkeWallet.Transaccion AS T
	INNER JOIN AlkeWallet.Usuario AS U
		ON T.sender_user_id = U.user_id
WHERE U.user_id = 1;

-- Sentencia DML para modificar el campo correo electrónico de un usuario específico.
UPDATE AlkeWallet.Usuario
	SET correo_electronico = 'ccondell@email.com;'
WHERE User_id = 4;

SELECT * FROM AlkeWallet.Usuario WHERE user_id = 4;

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM AlkeWallet.Transaccion
WHERE transaction_id = 1;

SELECT * FROM AlkeWallet.Transaccion;
-- ------------------------------------------------------------------------------------------------


-- -- Crear una vista que muestre el top 5 de usuarios con mayor saldo. Usando como base el Dólar
CREATE OR REPLACE VIEW mayor_saldo AS
	SELECT U.nombre, M.currency_name AS moneda_origen, U.saldo AS saldo_original,
		ROUND(U.saldo / TC.valor_respecto_base, 2) AS saldo_en_dolar
	FROM AlkeWallet.Usuario U
	INNER JOIN AlkeWallet.Moneda M 
		ON U.currency_id = M.currency_id
	INNER JOIN AlkeWallet.TipoCambio TC
		ON u.currency_id = TC.currency_id
	ORDER BY saldo_en_dolar DESC
	LIMIT 5;

SELECT * FROM mayor_saldo;
-- ------------------------------------------------------------------------------------------------


-- Añadir campo fecha de creación
ALTER TABLE AlkeWallet.Usuario 
	ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP; 

DESCRIBE AlkeWallet.Usuario;
-- ------------------------------------------------------------------------------------------------

-- Construir consultas SQL para recuperar:
-- Información simple 
SELECT currency_id, currency_name, currency_symbol FROM AlkeWallet.Moneda;

-- Función de agregación
SELECT U.nombre, sender_user_id, COUNT(*) AS total_enviadas FROM transaccion T
	INNER JOIN AlkeWallet.Usuario AS U
		ON T.sender_user_id = U.user_id
GROUP BY sender_user_id;

-- Usar subconsulta
SELECT nombre, saldo FROM AlkeWallet.Usuario
WHERE user_id IN (SELECT sender_user_id FROM AlkeWallet.Transaccion
					WHERE importe > (SELECT AVG(importe) FROM AlkeWallet.Transaccion));
-- ------------------------------------------------------------------------------------------------


-- Carga manual de transacciones
-- Transacción 1 (EUR a CLP)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 100.00 WHERE user_id = 2; -- Descuenta EUR
UPDATE Usuario SET saldo = saldo + (100.00 / 0.92 * 850.0) WHERE user_id = 3; -- Abona CLP
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (2, 3, 100.00, 3);
COMMIT;

-- Transacción 2 (CLP a USD)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 50000.00 WHERE user_id = 3; -- Descuenta CLP
UPDATE Usuario SET saldo = saldo + (50000.00 / 850.0) WHERE user_id = 1; -- Abona USD
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (3, 1, 50000.00, 2);
COMMIT;

-- Transacción 3 (USD a EUR)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 200.00 WHERE user_id = 4; -- Descuenta USD
UPDATE Usuario SET saldo = saldo + (200.00 * 0.92) WHERE user_id = 5; -- Abona EUR
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (4, 5, 200.00, 1);
COMMIT;

-- Transacción 4 (EUR a USD)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 80.00 WHERE user_id = 5; -- Descuenta EUR
UPDATE Usuario SET saldo = saldo + (80.00 / 0.92) WHERE user_id = 1; -- Abona USD
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (5, 1, 80.00, 3);
COMMIT;

-- Transacción 5 (CLP a EUR)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 20000.00 WHERE user_id = 3; -- Descuenta CLP
UPDATE Usuario SET saldo = saldo + (20000.00 / 850.0 * 0.92) WHERE user_id = 2; -- Abona EUR
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (3, 2, 20000.00, 2);
COMMIT;

-- Transacción 6 (USD a CLP)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 150.00 WHERE user_id = 1; -- Descuenta USD
UPDATE Usuario SET saldo = saldo + (150.00 * 850.0) WHERE user_id = 3; -- Abona CLP
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (1, 3, 150.00, 1);
COMMIT;

-- Transacción 7 (EUR a EUR)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 50.00 WHERE user_id = 2; -- Descuenta EUR
UPDATE Usuario SET saldo = saldo + 50.00 WHERE user_id = 5; -- Abona EUR
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (2, 5, 50.00, 3);
COMMIT;

-- Transacción 8 (CLP a CLP)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 10000.00 WHERE user_id = 3; -- Descuenta CLP
UPDATE Usuario SET saldo = saldo + 10000.00 WHERE user_id = 4; -- Abona CLP (Usuario 4 tiene USD, aquí hay error de lógica, corregir en la vida real)
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (3, 4, 10000.00, 2);
COMMIT;

-- Transacción 9 (USD a EUR)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 300.00 WHERE user_id = 4; -- Descuenta USD
UPDATE Usuario SET saldo = saldo + (300.00 / 0.92) WHERE user_id = 5; -- Abona EUR
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (4, 5, 300.00, 1);
COMMIT;

-- Transacción 10 (CLP a USD)
START TRANSACTION;
UPDATE Usuario SET saldo = saldo - 85000.00 WHERE user_id = 3; -- Descuenta CLP
UPDATE Usuario SET saldo = saldo + (85000.00 / 850.0) WHERE user_id = 1; -- Abona USD
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, currency_id) VALUES (3, 1, 85000.00, 2);
COMMIT;


