-- COMANDOS DDL
create sequence sequence_codigo_cliente;
create table cliente (
    codigo_cliente bigint default nextval('sequence_codigo_cliente'),
    cpf varchar(11) not null,
    nome text not null,
    email text not null,
    telefone text not null,
    cidade text not null,
    bairro text not null,
    numero_rua int not null,
    cep varchar(8) not null,
    perfil text not null,
    login text not null,
    senha_hash text not null,
    salt text,
    
    constraint pk_codigo_cliente primary key (codigo_cliente),
    constraint uk_cpf_cliente unique (cpf),
    constraint uk_email_cliente unique (email)
);

create sequence sequence_codigo_compra;
create table compra (
    codigo_compra bigint default nextval('sequence_codigo_compra'),
    codigo_cliente bigint,
    data timestamp with time zone default current_timestamp not null,
    valor numeric(10, 2) not null,
    total numeric(10, 2) not null,
    desconto numeric(10, 2) default 0.00,
    codigo_reserva text not null,
    total_bagagens int default 1 not null,
    tipo_pagamento text not null,

    constraint pk_codigo_compra primary key (codigo_compra),
    constraint fk_codigo_cliente foreign key (codigo_cliente) references cliente(codigo_cliente),
    constraint uk_codigo_reserva_compra unique (codigo_reserva)
);

create sequence sequence_codigo_registro_aeronave;
create table aeronave (
    codigo_registro_aeronave int default nextval('sequence_codigo_registro_aeronave'),
    modelo text not null,
    fabricante text not null,
    capacidade int not null,

    constraint pk_codigo_registro_aeronave primary key (codigo_registro_aeronave)
);

create sequence sequence_codigo_registro_piloto;
create table piloto (
    codigo_registro_piloto int default nextval('sequence_codigo_registro_piloto'),
    nome text not null,

    constraint pk_codigo_registro_piloto primary key (codigo_registro_piloto)
);

create sequence sequence_codigo_licenca;
create table licenca (
    codigo_licenca int default nextval('sequence_codigo_licenca'),
    tipo text not null,

    constraint pk_codigo_licenca primary key (codigo_licenca)
);

create table piloto_licenca (
    codigo_registro_piloto int,
    codigo_licenca int,
    data_emissao date default current_date not null,
    data_validade date default current_date not null,

    constraint pk_registro_licenca_piloto primary key (codigo_registro_piloto, codigo_licenca),
    constraint fk_codigo_registro_piloto foreign key (codigo_registro_piloto) references piloto(codigo_registro_piloto)
        on delete cascade
        on update cascade,
    constraint fk_codigo_licenca foreign key (codigo_licenca) references licenca(codigo_licenca)
        on delete cascade
        on update cascade
);

create sequence sequence_codigo_voo;
create table voo (
    codigo_voo bigint default nextval('sequence_codigo_voo'),
    destino text not null,
    horario_saida timestamp default current_timestamp not null,
    horario_chegada timestamp default current_timestamp not null,
    codigo_registro_aeronave int,
    codigo_registro_piloto int,

    constraint pk_codigo_voo primary key (codigo_voo),
    constraint fk_codigo_registro_aeronave foreign key (codigo_registro_aeronave) references aeronave(codigo_registro_aeronave),
    constraint fk_codigo_registro_piloto foreign key (codigo_registro_piloto) references piloto(codigo_registro_piloto)
    -- nas fk's do voo não vai ter delete cascade pois a ultima o coisa que deveria ser excluindo em cascata seria a compra, mas a compra não pode ser excluida por consequência (somente se o voo for cancelado).
);

create sequence sequence_numero_passagem;
create table passagem (
    numero_passagem bigint default nextval('sequence_numero_passagem'),
    preco numeric(10,2) not null,
    assento text not null,
    classe text not null,
    codigo_compra bigint null,
    codigo_voo bigint,

    constraint pk_numero_pasagem primary key (numero_passagem),
    constraint fk_codigo_compra foreign key (codigo_compra) references compra(codigo_compra)
        on delete set null -- Se a compra for excluida eu simplesmente seto para null a coluna, assim, possibilitando vender ela novamente...
        on update cascade,
    constraint fk_codigo_voo foreign key (codigo_voo) references voo(codigo_voo)
        on delete cascade -- Passagem depende do voo, então se voo foi excluido a passagem também deve ser removida.
        on update cascade
);

-- COMANDOS DML

-- Inserir dados para tabela licenca
insert into licenca (tipo)
values
    ('PPL - Private Pilot License'),
    ('CPL - Commercial Pilot License'),
    ('ATPL - Airline Transport Pilot License'),
    ('IFR - Instrument Flight Rules'),
    ('CFI - Certified Flight Instructor'),
    ('Type Rating - Airbus A320'),
    ('Type Rating - Boeing 737'),
    ('Type Rating - Gulfstream G650'),
    ('Type Rating - Cessna Citation X'),
    ('Type Rating - Embraer E190');

-- Inserir dados para tabela piloto
insert into piloto (nome)
values
    ('Carlos Oliveira'),
    ('Ana Silva'),
    ('Rodrigo Santos'),
    ('Marta Lima'),
    ('Lucas Souza'),
    ('Beatriz Oliveira'),
    ('Rafaela Costa'),
    ('Thiago Martins'),
    ('Patricia Pereira'),
    ('Pedro Almeida');

-- Inserir dados para tabela piloto_licenca
insert into piloto_licenca (codigo_registro_piloto, codigo_licenca, data_emissao, data_validade)
values
    (1, 1, current_date, current_date + interval '2 years'),
    (2, 2, current_date, current_date + interval '2 years'),
    (3, 3, current_date, current_date + interval '2 years'),
    (4, 4, current_date, current_date + interval '2 years'),
    (5, 5, current_date, current_date + interval '2 years'),
    (6, 6, current_date, current_date + interval '2 years'),
    (7, 7, current_date, current_date + interval '2 years'),
    (8, 8, current_date, current_date + interval '2 years'),
    (9, 9, current_date, current_date + interval '2 years'),
    (10, 10, current_date, current_date + interval '2 years'),
    (1, 6, current_date, current_date + interval '1 year'),
    (2, 7, current_date, current_date + interval '1 year'),
    (3, 8, current_date, current_date + interval '1 year'),
    (4, 9, current_date, current_date + interval '1 year'),
    (5, 10, current_date, current_date + interval '1 year'),
    (6, 1, current_date, current_date + interval '1 year'),
    (7, 2, current_date, current_date + interval '1 year'),
    (8, 3, current_date, current_date + interval '1 year'),
    (9, 4, current_date, current_date + interval '1 year'),
    (10, 5, current_date, current_date + interval '1 year');

-- Inserir dados para tabela aeronave
insert into aeronave (modelo, fabricante, capacidade)
values
    ('Boeing 737', 'Boeing', 150),
    ('Airbus A320', 'Airbus', 180),
    ('Boeing 777', 'Boeing', 350),
    ('Airbus A380', 'Airbus', 500),
    ('Embraer E190', 'Embraer', 100),
    ('Bombardier CRJ900', 'Bombardier', 90),
    ('Cessna 172', 'Cessna', 4),
    ('Gulfstream G650', 'Gulfstream', 14),
    ('Dassault Falcon 7X', 'Dassault', 12),
    ('Piper PA-28', 'Piper', 4),
    ('Antonov An-124', 'Antonov', 500),
    ('Cessna Citation X', 'Cessna', 12);

-- Inserir dados para tabela voo
insert into voo (destino, horario_saida, horario_chegada, codigo_registro_aeronave, codigo_registro_piloto)
values
    ('Los Angeles', current_timestamp, current_timestamp + interval '7 hours', 3, 1),
    ('Paris', current_timestamp, current_timestamp + interval '9 hours', 4, 2),
    ('Tokyo', current_timestamp, current_timestamp + interval '12 hours', 5, 3),
    ('Sydney', current_timestamp, current_timestamp + interval '14 hours', 6, 4),
    ('Dubai', current_timestamp, current_timestamp + interval '10 hours', 7, 5),
    ('Moscow', current_timestamp, current_timestamp + interval '8 hours', 8, 6),
    ('Berlin', current_timestamp, current_timestamp + interval '6 hours', 9, 7),
    ('Rome', current_timestamp, current_timestamp + interval '5 hours', 10, 8),
    ('Madrid', current_timestamp, current_timestamp + interval '4 hours', 11, 9),
    ('Beijing', current_timestamp, current_timestamp + interval '11 hours', 12, 10);

-- Inserir dados para tabela cliente
insert into cliente (cpf, nome, email, telefone, cidade, bairro, numero_rua, cep, perfil, login, senha_hash, salt)
values
    ('12345678901', 'João Silva', 'joao@example.com', '(11) 9999-9999', 'São Paulo', 'Centro', 123, '01000000', 'cliente', 'joao.silva', 'hash123', 'salt123'),
    ('98765432109', 'Maria Souza', 'maria@example.com', '(21) 8888-8888', 'Rio de Janeiro', 'Copacabana', 456, '22000000', 'cliente', 'maria.souza', 'hash456', 'salt456'),
    ('11122233344', 'Ana Oliveira', 'ana@example.com', '(31) 7777-7777', 'Belo Horizonte', 'Savassi', 789, '30000000', 'cliente', 'ana.oliveira', 'hash789', 'salt789'),
    ('55566677788', 'Pedro Santos', 'pedro@example.com', '(41) 5555-5555', 'Curitiba', 'Batel', 1011, '80000000', 'cliente', 'pedro.santos', 'hash1011', 'salt1011'),
    ('99988877766', 'Mariana Costa', 'mariana@example.com', '(51) 3333-3333', 'Porto Alegre', 'Moinhos de Vento', 1213, '90000000', 'cliente', 'mariana.costa', 'hash1213', 'salt1213'),
    ('33322211100', 'Lucas Pereira', 'lucas@example.com', '(61) 2222-2222', 'Brasília', 'Asa Sul', 1415, '70000000', 'cliente', 'lucas.pereira', 'hash1415', 'salt1415'),
    ('77766655544', 'Camila Almeida', 'camila@example.com', '(71) 9999-9999', 'Salvador', 'Barra', 1617, '40000000', 'cliente', 'camila.almeida', 'hash1617', 'salt1617'),
    ('44455566677', 'Rafaela Lima', 'rafaela@example.com', '(81) 8888-8888', 'Recife', 'Boa Viagem', 1819, '50000000', 'cliente', 'rafaela.lima', 'hash1819', 'salt1819'),
    ('88899900011', 'Fernando Oliveira', 'fernando@example.com', '(85) 7777-7777', 'Fortaleza', 'Meireles', 2021, '60000000', 'cliente', 'fernando.oliveira', 'hash2021', 'salt2021'),
    ('22233344455', 'Carolina Silva', 'carolina@example.com', '(91) 6666-6666', 'Belém', 'Nazaré', 2223, '66000000', 'cliente', 'carolina.silva', 'hash2223', 'salt2223'),
    ('66677788899', 'Thiago Sousa', 'thiago@example.com', '(99) 5555-5555', 'Manaus', 'Adrianópolis', 2425, '69000000', 'cliente', 'thiago.sousa', 'hash2425', 'salt2425');

-- Inserir dados para tabela compra
insert into compra (codigo_cliente, data, valor, total, desconto, codigo_reserva, total_bagagens, tipo_pagamento)
values
    (1, current_timestamp, 1500.00, 1500.00, 0.00, 'ABC123', 2, 'Cartão de Crédito'),
    (2, current_timestamp, 1800.00, 1800.00, 0.00, 'DEF456', 1, 'Boleto'),
    (3, current_timestamp, 2500.00, 2500.00, 0.00, 'GHI789', 3, 'Cartão de Débito'),
    (4, current_timestamp, 1200.00, 1200.00, 0.00, 'JKL012', 1, 'Pix'),
    (5, current_timestamp, 3000.00, 3000.00, 0.00, 'MNO345', 2, 'Transferência Bancária'),
    (6, current_timestamp, 2200.00, 2200.00, 0.00, 'PQR678', 1, 'Cartão de Crédito'),
    (7, current_timestamp, 1900.00, 1900.00, 0.00, 'STU901', 2, 'Boleto'),
    (8, current_timestamp, 2800.00, 2800.00, 0.00, 'VWX234', 3, 'Cartão de Débito'),
    (9, current_timestamp, 2100.00, 2100.00, 0.00, 'YZA567', 1, 'Pix'),
    (10, current_timestamp, 3200.00, 3200.00, 0.00, 'BCD890', 2, 'Transferência Bancária');

-- Inserir dados para tabela passagem
insert into passagem (preco, assento, classe, codigo_compra, codigo_voo)
values
    (500.00, 'A1', 'Primeira Classe', 1, 1),
    (400.00, 'B2', 'Classe Executiva', 2, 2),
    (600.00, 'C3', 'Classe Econômica', 3, 3),
    (300.00, 'D4', 'Classe Econômica', 4, 4),
    (700.00, 'E5', 'Primeira Classe', 5, 5),
    (450.00, 'F6', 'Classe Executiva', 6, 6),
    (550.00, 'G7', 'Classe Econômica', 7, 7),
    (350.00, 'H8', 'Classe Econômica', 8, 8),
    (800.00, 'I9', 'Primeira Classe', 9, 9),
    (600.00, 'J10', 'Classe Executiva', 10, 10);