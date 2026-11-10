create database TCC;

use TCC;

CREATE TABLE turma (
id_turma INT auto_increment PRIMARY KEY,
nome_turma VARCHAR (30) NOT NULL,
ano YEAR NOT NULL
);

CREATE TABLE usuarios (
id_usuario INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR (100) NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL,
senha_hash VARCHAR (255) NOT NULL,
tipo_usuario ENUM ('aluno', 'comissao','adm') NOT NULL,
id_turma INT, CONSTRAINT fk_id_turma FOREIGN KEY (id_turma) REFERENCES turma(id_turma),
ativo BOOLEAN DEFAULT TRUE,
data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE eventos (
id_evento INT AUTO_INCREMENT PRIMARY KEY,
nome_evento VARCHAR (100) NOT NULL,
descricao TEXT,
data_evento DATE NOT NULL,
hora_inicio TIME,
hora_fim TIME,
local VARCHAR (255),
status ENUM ('agendado','realizado','cancelado') NOT NULL DEFAULT 'agendado'
);

CREATE TABLE campanhas_produtos(
id_campanha INT AUTO_INCREMENT PRIMARY KEY,
nome_campanha VARCHAR (255) NOT NULL,
descricao TEXT,
data_inicio DATE NOT NULL,
data_fim DATE ,
status ENUM ('planejada','ativa','encerrada','cancelada') NOT NULL DEFAULT 'planejada');

CREATE TABLE produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
id_campanha INT NOT NULL, CONSTRAINT fk_id_campanha FOREIGN KEY (id_campanha) REFERENCES campanhas_produtos(id_campanha),
nome_produto VARCHAR (100) NOT NULL,
descricao TEXT,
preco_unitario DECIMAL (10,2) NOT NULL,
ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE rifas(
id_rifa INT AUTO_INCREMENT PRIMARY KEY,
id_evento INT NOT NULL, CONSTRAINT fk_id_evento FOREIGN KEY (id_evento) REFERENCES eventos (id_evento),
valor_numero DECIMAL (10,2) NOT NULL,
quantidade_total INT NOT NULL,
data_sorteio DATE,
status ENUM ('planejada','ativa', 'encerrada','cancelada') default 'planejada'
);

CREATE TABLE distribuicoes_rifas (
id_distribuicao_rifa INT AUTO_INCREMENT PRIMARY KEY,
id_rifa INT NOT NULL, CONSTRAINT fk_id_rifa FOREIGN KEY (id_rifa) REFERENCES rifas (id_rifa),
id_aluno INT NOT NULL, CONSTRAINT fk_id_aluno FOREIGN KEY (id_aluno) REFERENCES usuarios (id_usuario),
quantidade_distribuida INT NOT NULL
);

CREATE TABLE arrecadacoes (
id_arrecadacao INT AUTO_INCREMENT PRIMARY KEY,
nome_arrecadacao VARCHAR (100) NOT NULL,
descricao text,
data_inicio DATE NOT NULL,
data_fim DATE,
status ENUM('planejada', 'ativa','encerrada', 'cancelada') DEFAULT 'planejada'
);

CREATE TABLE arrecadacoes_turmas (
    id_arrecadacao_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_arrecadacao INT NOT NULL,
    CONSTRAINT fk_id_arrecadacao FOREIGN KEY (id_arrecadacao) REFERENCES arrecadacoes(id_arrecadacao),
    id_turma INT NOT NULL,
    CONSTRAINT fk_id_turma_arrecadacao FOREIGN KEY (id_turma) REFERENCES turma(id_turma),
    quantidade_arrecadada DECIMAL(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE prestacoes_contas (
id_prestacao INT AUTO_INCREMENT PRIMARY KEY,
id_aluno INT NOT NULL, CONSTRAINT ce_id_aluno FOREIGN KEY (id_aluno) REFERENCES usuarios (id_usuario) ,
id_rifa INT NOT NULL, CONSTRAINT ce_id_rifa FOREIGN KEY (id_rifa) REFERENCES rifas(id_rifa),
quantidade_vendida INT NOT NULL DEFAULT 0,
valor_entregue DECIMAL (10,2) NOT NULL,
data_prestacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
observacao TEXT
);

CREATE TABLE movimentacoes_financeiras (
id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
tipo ENUM ('entrada', 'saida') NOT NULL,
descricao TEXT NOT NULL,
valor DECIMAL (10,2) NOT NULL,
data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
id_prestacao INT UNIQUE, CONSTRAINT fk_id_prestacao FOREIGN KEY (id_prestacao) REFERENCES prestacoes_contas (id_prestacao)
);
