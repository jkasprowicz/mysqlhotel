CREATE SCHEMA IF NOT EXISTS hospedar;
USE hospedar;

CREATE TABLE Hotel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE Quarto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    tipo ENUM('Standard', 'Deluxe', 'Suíte') NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,
    hotel_id INT,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(id)
);

CREATE TABLE Cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    cpf VARCHAR(11) UNIQUE NOT NULL
);


CREATE TABLE Hospedagem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    quarto_id INT,
    hotel_id INT,
    data_checkin DATE NOT NULL,
    data_checkout DATE,
    valor_total DECIMAL(10, 2),
    estado ENUM('reserva', 'hospedado', 'finalizada', 'cancelada') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(id),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(id)
);

INSERT INTO Hotel (nome, cidade, rating) VALUES
('Hotel A', 'São Paulo', 5),
('Hotel B', 'Rio de Janeiro', 4),
('Hotel C', 'Salvador', 3),
('Hotel D', 'Curitiba', 5),
('Hotel E', 'Brasília', 4);


INSERT INTO Quarto (numero, tipo, preco_diaria, hotel_id) VALUES
(101, 'Standard', 150.00, 1), (102, 'Deluxe', 200.00, 1), (103, 'Suíte', 300.00, 1), (104, 'Standard', 150.00, 1), (105, 'Deluxe', 200.00, 1),
(201, 'Standard', 140.00, 2), (202, 'Deluxe', 220.00, 2), (203, 'Suíte', 320.00, 2), (204, 'Standard', 140.00, 2), (205, 'Deluxe', 220.00, 2),
(301, 'Standard', 130.00, 3), (302, 'Deluxe', 210.00, 3), (303, 'Suíte', 310.00, 3), (304, 'Standard', 130.00, 3), (305, 'Deluxe', 210.00, 3),
(401, 'Standard', 160.00, 4), (402, 'Deluxe', 240.00, 4), (403, 'Suíte', 340.00, 4), (404, 'Standard', 160.00, 4), (405, 'Deluxe', 240.00, 4),
(501, 'Standard', 170.00, 5), (502, 'Deluxe', 250.00, 5), (503, 'Suíte', 350.00, 5), (504, 'Standard', 170.00, 5), (505, 'Deluxe', 250.00, 5);

INSERT INTO Cliente (nome, email, telefone, cpf) VALUES
('João Silva', 'joao@gmail.com', '11987654321', '12345678901'),
('Maria Souza', 'maria@gmail.com', '21987654321', '23456789012'),
('Carlos Lima', 'carlos@gmail.com', '31987654321', '34567890123'),
('Ana Paula', 'ana@gmail.com', '41987654321', '45678901234'),
('Pedro Santos', 'pedro@gmail.com', '51987654321', '56789012345');


INSERT INTO Hospedagem (cliente_id, quarto_id, hotel_id, data_checkin, data_checkout, valor_total, estado) VALUES
(1, 1, 1, '2024-09-01', '2024-09-05', 600.00, 'finalizada'),
(2, 2, 1, '2024-09-02', '2024-09-06', 880.00, 'finalizada'),
(3, 3, 2, '2024-09-03', '2024-09-07', 1240.00, 'finalizada'),
(4, 4, 2, '2024-09-04', '2024-09-08', 960.00, 'finalizada'),
(5, 5, 3, '2024-09-05', '2024-09-09', 1000.00, 'finalizada'),

(1, 1, 1, '2024-09-10', NULL, NULL, 'hospedado'),
(2, 2, 1, '2024-09-11', NULL, NULL, 'hospedado'),
(3, 3, 2, '2024-09-12', NULL, NULL, 'hospedado'),
(4, 4, 2, '2024-09-13', NULL, NULL, 'hospedado'),
(5, 5, 3, '2024-09-14', NULL, NULL, 'hospedado'),

(1, 1, 1, '2024-09-15', '2024-09-17', 600.00, 'reserva'),
(2, 2, 1, '2024-09-16', '2024-09-18', 660.00, 'reserva'),
(3, 3, 2, '2024-09-17', '2024-09-19', 720.00, 'reserva'),
(4, 1, 1, '2024-09-18', '2024-09-20', 900.00, 'reserva'),
(5, 2, 2, '2024-09-19', '2024-09-21', 980.00, 'reserva'),

(1, 1, 1, '2024-09-20', NULL, NULL, 'cancelada'),
(2, 2, 2, '2024-09-21', NULL, NULL, 'cancelada'),
(3, 3, 3, '2024-09-22', NULL, NULL, 'cancelada'),
(4, 5, 4, '2024-09-23', NULL, NULL, 'cancelada'),
(5, 4, 5, '2024-09-24', NULL, NULL, 'cancelada');

-- item 5.a
SELECT 
    h.nome AS nome_hotel,
    h.cidade AS cidade_hotel,
    q.tipo AS tipo_quarto,
    q.preco_diaria AS preco_diaria_quarto
FROM 
    Hotel h
JOIN 
    Quarto q ON h.id = q.hotel_id;


-- item 5.b
SELECT c.nome AS cliente, q.numero AS quarto, h.nome AS hotel, ho.data_checkin, ho.data_checkout, ho.valor_total
FROM Hospedagem ho
JOIN Cliente c ON ho.cliente_id = c.id
JOIN Quarto q ON ho.quarto_id = q.id
JOIN Hotel h ON q.hotel_id = h.id
WHERE ho.estado = 'finalizada';

-- item 5.c
SELECT 
    hsp.data_checkin,
    hsp.data_checkout,
    q.numero AS quarto_numero,
    h.nome AS hotel_nome,
    hsp.valor_total,
    hsp.estado
FROM 
    Hospedagem hsp
JOIN 
    Quarto q ON hsp.quarto_id = q.id
JOIN 
    Hotel h ON q.hotel_id = h.id
WHERE 
    hsp.cliente_id = 1
ORDER BY 
    hsp.data_checkin;
    
-- item 5.d
SELECT 
    c.id,
    c.nome,
    COUNT(hsp.id) AS num_hospedagens
FROM 
    Cliente c
JOIN 
    Hospedagem hsp ON c.id = hsp.cliente_id
GROUP BY 
    c.id, c.nome
ORDER BY 
    num_hospedagens DESC
LIMIT 1;

-- item 5.e
SELECT 
    c.nome AS cliente_nome,
    q.numero AS quarto_numero,
    h.nome AS hotel_nome
FROM 
    Hospedagem hsp
JOIN 
    Cliente c ON hsp.cliente_id = c.id
JOIN 
    Quarto q ON hsp.quarto_id = q.id
JOIN 
    Hotel h ON q.hotel_id = h.id
WHERE 
    hsp.estado = 'cancelada';

-- item 5.f
SELECT 
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    SUM(hsp.valor_total) AS total_receita
FROM 
    Hospedagem hsp
JOIN 
    Hotel h ON hsp.hotel_id = h.id
WHERE 
    hsp.estado = 'finalizada'
GROUP BY 
    h.id, h.nome, h.cidade
ORDER BY 
    total_receita DESC;


-- item 5.g
SELECT 
    DISTINCT c.nome AS cliente_nome
FROM 
    Hospedagem hsp
JOIN 
    Cliente c ON hsp.cliente_id = c.id
JOIN 
    Quarto q ON hsp.quarto_id = q.id
JOIN 
    Hotel h ON q.hotel_id = h.id
WHERE 
    h.nome = 'Hotel A' 
    AND hsp.estado = 'reserva';




-- item 5.h
SELECT 
    c.nome AS cliente_nome,
    SUM(hsp.valor_total) AS total_gasto
FROM 
    Hospedagem hsp
JOIN 
    Cliente c ON hsp.cliente_id = c.id
WHERE 
    hsp.estado = 'finalizada'
GROUP BY 
    c.id, c.nome
ORDER BY 
    total_gasto DESC;
    
-- item 5.i
SELECT 
    q.numero AS quarto_numero
FROM 
    Quarto q
LEFT JOIN 
    Hospedagem hsp ON q.id = hsp.quarto_id
WHERE 
    hsp.id IS NULL;

-- item 5.j
SELECT 
    h.nome AS hotel_nome,
    q.tipo AS quarto_tipo,
    AVG(q.preco_diaria) AS media_preco_diaria
FROM 
    Quarto q
JOIN 
    Hotel h ON q.hotel_id = h.id
GROUP BY 
    h.nome, q.tipo;

-- item 5.k
SET SQL_SAFE_UPDATES = 0;


DELETE FROM Hospedagem
WHERE estado = 'cancelada';


-- item 5.l

ALTER TABLE Hospedagem
ADD COLUMN checkin_realizado BOOLEAN;

UPDATE Hospedagem
SET checkin_realizado = CASE
    WHEN estado IN ('finalizada', 'hospedado') THEN TRUE
    ELSE FALSE
END;


-- item 5.m

CREATE VIEW Reservas_Atuais AS
SELECT
    c.nome AS cliente_nome,
    q.numero AS quarto_numero,
    q.tipo AS quarto_tipo,
    q.preco_diaria AS quarto_preco_diaria,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    hsp.data_checkin,
    hsp.data_checkout,
    hsp.valor_total
FROM
    Hospedagem hsp
JOIN
    Cliente c ON hsp.cliente_id = c.id
JOIN
    Quarto q ON hsp.quarto_id = q.id
JOIN
    Hotel h ON q.hotel_id = h.id
WHERE
    hsp.estado = 'reserva'
    AND hsp.data_checkin >= NOW()
ORDER BY
    hsp.data_checkin;

SHOW FULL TABLES IN hospedar WHERE TABLE_TYPE = 'VIEW';

SELECT * FROM Reservas_Atuais;





