-- Proyecto FINAL Equipo 4
-- Script 'creaBase.sql' (DDL)
-- Semestre 2022-2

-- Creacion de base de datos:

-- CREATE DATABASE PRUEBAS_PROYECTO_FINAL;
CREATE DATABASE PROYECTO_FINAL_EQUIPO4_2022_2;
go

-- use PRUEBAS_PROYECTO_FINAL;
use PROYECTO_FINAL_EQUIPO4_2022_2;
go

-- Creacion de esquemas
CREATE SCHEMA persona;
go

CREATE SCHEMA logistica;
go

CREATE SCHEMA venta;
go

CREATE SCHEMA catalogo;
go

-- Creacion de tablas:
CREATE TABLE persona.Usuario(
    id_usuario INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_USUARIO_USUARIO PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    ap_paterno VARCHAR(40) NOT NULL,
    ap_materno VARCHAR(40) NULL,
    username VARCHAR(25) CONSTRAINT U_USERNAME UNIQUE NOT NULL, 
    email VARCHAR(40) CONSTRAINT U_EMAIL UNIQUE NOT NULL,
    curp varchar(18) CONSTRAINT U_CURP UNIQUE NOT NULL, 
    contrasena VARCHAR(30) CONSTRAINT U_CONTRASENA UNIQUE NOT NULL,
    fecha_nacimiento DATE NULL ,
    -- edad as (CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),fecha_nacimiento,112))/10000,
    genero CHAR(1) NOT NULL, -- (CS4)
    tipo_registrado CHAR(1) NULL,
    CONSTRAINT CK_TIPO_REGISTRADO_USUARIO CHECK (tipo_registrado IN ('C','V','G')), -- C -> Comprador , V -> Vendedor & G -> Gestor
    CONSTRAINT CK_GENERO_USUARIO CHECK (genero IN ('H','M')),
    CONSTRAINT CK_EDAD_USUARIO CHECK ((CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),fecha_nacimiento,112))/10000 >= 18), -- CS2
    CONSTRAINT CK_CURP_USUARIO CHECK (DATALENGTH(curp) = 18),
    CONSTRAINT CK_CONTRASENA_USUARIO CHECK (DATALENGTH(contrasena) >= 8),
    CONSTRAINT CK_EMAIL_USUARIO CHECK (email LIKE '%___@___%.__%')
);

CREATE TABLE persona.Domicilio(
    id_domicilio INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_DOMICILIO_DOMICILIO PRIMARY KEY,
    calle VARCHAR(40) NOT NULL,
    num_interior TINYINT NULL,
    alcaldia VARCHAR(40) NOT NULL,
    colonia VARCHAR(40) NOT NULL,
    num_exterior TINYINT NOT NULL,
    id_usuario INTEGER CONSTRAINT FK_ID_USUARIO_DOMICILIO FOREIGN KEY REFERENCES persona.Usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE persona.Telefono(
    id_telefono INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_TELEFONO_TELEFONO PRIMARY KEY,
    telefono VARCHAR(10) CONSTRAINT U_TELEFONO UNIQUE NOT NULL, 
    id_usuario INTEGER FOREIGN KEY REFERENCES persona.Usuario(id_usuario)
);

CREATE TABLE persona.Comprador(
    id_usuario INTEGER CONSTRAINT PK_ID_USUARIO_COMPRADOR PRIMARY KEY ,
	CONSTRAINT FK_ID_USUARIO_COMPRADOR FOREIGN KEY (id_usuario) REFERENCES persona.Usuario(id_usuario) ON DELETE CASCADE
);


CREATE TABLE persona.Vendedor(
    id_usuario INTEGER CONSTRAINT PK_ID_USUARIO_VENDEDOR PRIMARY KEY ,
    sueldo MONEY NOT NULL, -- CS8
    CONSTRAINT CK_SUELDO CHECK (sueldo > 5000 ),
	CONSTRAINT FK_ID_USUARIO_VENDEDOR FOREIGN KEY (id_usuario) REFERENCES persona.Usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE persona.Gestor(
    id_usuario INTEGER CONSTRAINT PK_ID_USUARIO_GESTOR PRIMARY KEY,
    supervisor_gestor INTEGER NULL FOREIGN KEY REFERENCES persona.Gestor(id_usuario), -- Recursividad
	CONSTRAINT FK_ID_USUARIO_GESTOR FOREIGN KEY (id_usuario) REFERENCES persona.Usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE venta.Cesta(
    id_cesta INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_CESTA PRIMARY KEY,
    fecha_registro DATE NOT NULL CONSTRAINT DF_FECHA_REGISTRO DEFAULT GETDATE(),
    estado CHAR(1) CONSTRAINT CK_ESTADO_CESTA CHECK (estado in('A','E','C')) , -- (CS9) A:activa, E:eliminada C:comprada
	id_usuario INTEGER CONSTRAINT FK_ID_USUARIO_CESTA FOREIGN KEY REFERENCES persona.Comprador(id_usuario) ON DELETE CASCADE
);

CREATE TABLE catalogo.Categoria(
    id_categoria INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_CATEGORIA_CATEGORIA PRIMARY KEY,
    categoria_padre INTEGER CONSTRAINT FK_CATEGORIA_PADRE_CATEGORIA FOREIGN KEY REFERENCES catalogo.categoria(id_categoria),
    nombre VARCHAR(40) NOT NULL,
    id_gestor INTEGER CONSTRAINT FK_ID_GESTOR_CATEGORIA FOREIGN KEY REFERENCES persona.Gestor(id_usuario) ON DELETE CASCADE
);

CREATE TABLE catalogo.Producto(
    clave INTEGER IDENTITY(1,1) CONSTRAINT PK_CLAVE_PRODUCTO PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    cantidad_re_orden INTEGER NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    descripcion_detallada VARCHAR(250) NOT NULL,
    precio MONEY NOT NULL,
    stock INTEGER NOT NULL,
    id_gestor INTEGER NOT NULL,
	id_categoria INTEGER NOT NULL,
 	CONSTRAINT FK_ID_GESTOR_PRODUCTO FOREIGN KEY (id_gestor) REFERENCES persona.Gestor(id_usuario) ON DELETE CASCADE,
	CONSTRAINT FK_ID_CATEGORIA_PRODUCTO FOREIGN KEY (id_categoria) REFERENCES catalogo.Categoria(id_categoria)
);

CREATE TABLE logistica.Imagen(
    id_imagen INTEGER IDENTITY(1,1) Constraint PK_ID_IMAGEN_IMAGEN PRIMARY KEY,
    imagen IMAGE NOT NULL,
    clave INTEGER CONSTRAINT FK_CLAVE_IMAGEN FOREIGN KEY REFERENCES catalogo.Producto(clave) ON DELETE CASCADE
);

CREATE TABLE venta.CestaProducto(
    id_cesta integer,
    clave INTEGER,
    cantidad SMALLINT  NOT NULL,
    CONSTRAINT FK_ID_CESTA_CESTA_PRODUCTO FOREIGN KEY(id_cesta) REFERENCES venta.Cesta(id_cesta) ON DELETE CASCADE,
    CONSTRAINT FK_CLAVE_CESTA_PRODUCTO FOREIGN KEY(clave) REFERENCES catalogo.Producto(clave) ,
    CONSTRAINT PK_ID_CESTA_CLAVE_CESTA_PRODUCTO PRIMARY KEY(id_cesta,clave)
);

CREATE TABLE logistica.Oferta(
    id_oferta INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_OFERTA_OFERTA PRIMARY KEY,
    tipo VARCHAR(40),
    descripcion VARCHAR(50),
    fecha_inicio DATETIME, 
    fecha_fin DATETIME,
    id_usuario integer,
	CONSTRAINT FK_ID_USUARIO_OFERTA FOREIGN KEY (id_usuario) REFERENCES persona.Gestor(id_usuario) ON DELETE CASCADE,
	CONSTRAINT CK_FECHA_FIN_OFERTA CHECK (fecha_fin<=fecha_inicio+40)-- (CS5 no mas de 40 dias)
);

CREATE TABLE logistica.OfertaProducto(
    id_oferta INTEGER,
    clave INTEGER,
    CONSTRAINT FK_ID_OFERTA_OFERTA_PRODUCTO FOREIGN KEY(id_oferta) REFERENCES logistica.Oferta(id_oferta) ON DELETE CASCADE,
    CONSTRAINT FK_CLAVE_OFERTA_PRODUCTO FOREIGN KEY(clave) REFERENCES catalogo.Producto(clave) ,
    CONSTRAINT PK_ID_OFERTA_CLAVE_OFERTA_PRODUCTO PRIMARY KEY(id_oferta,clave)
);


CREATE TABLE venta.Suscribe(
    id_usuario integer CONSTRAINT FK_ID_USUARIO_SUSCRIBE FOREIGN KEY REFERENCES persona.Usuario(id_usuario) ON DELETE CASCADE,
    clave integer FOREIGN KEY REFERENCES catalogo.Producto(clave),
    CONSTRAINT PK_ID_USUARIO_CLAVE_SUSCRIBE PRIMARY KEY (id_usuario,clave)
);

CREATE TABLE logistica.MedioEnvio(
    id_medio INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_MEDIO_MEDIO_ENVIO PRIMARY KEY,
    medio VARCHAR(40) NOT NULL
);

CREATE TABLE venta.Compra(
    id_compra INTEGER IDENTITY(1,1) CONSTRAINT PK_ID_COMPRA_COMPRA PRIMARY KEY,
    id_cesta INTEGER CONSTRAINT FK_ID_CESTA_COMPRA FOREIGN KEY REFERENCES venta.Cesta(id_cesta),
    tipo_compra CHAR(1) NOT NULL CONSTRAINT CK_TIPO_COMPRA_COMPRA CHECK(tipo_compra in ('L','F')), -- L -> En linea & F -> Fisica
    fecha_compra DATETIME NOT NULL CONSTRAINT DF_YourTable DEFAULT GETDATE(), --(CS6) Si el tiempo es menor a 48 h se puede realizar una cancelacion
    iva MONEY NOT NULL,
    monto_total MONEY NULL, -- Esta es calculada
    costo_cancelacion AS (monto_total*.15), -- CS7 Se cobra el 15%
    id_medio INTEGER CONSTRAINT FK_ID_MEDIO_COMPRA FOREIGN KEY REFERENCES logistica.MedioEnvio(id_medio) ON DELETE CASCADE
);

CREATE TABLE venta.EnLinea(
    id_compra INTEGER CONSTRAINT PK_ID_COMPRA_EN_LINEA PRIMARY KEY,
    CONSTRAINT FK_ID_COMPRA_EN_LINEA FOREIGN KEY(id_compra) REFERENCES venta.Compra(id_compra) ON DELETE CASCADE,
    sistema_transporte VARCHAR(40) NOT NULL
);

CREATE TABLE venta.Fisica(
    id_compra INTEGER CONSTRAINT PK_ID_COMPRA_FISICA PRIMARY KEY,
    CONSTRAINT FK_ID_COMPRA_FISICA FOREIGN KEY (id_compra)REFERENCES venta.Compra(id_compra) ON DELETE CASCADE,
    id_usuario integer,
	CONSTRAINT FK_ID_USUARIO_PRODUCTO FOREIGN KEY (id_usuario) REFERENCES persona.Vendedor(id_usuario) ON DELETE CASCADE
);

CREATE UNIQUE NONCLUSTERED INDEX NC_categoriaNombre
ON catalogo.Categoria(nombre);

CREATE UNIQUE NONCLUSTERED INDEX NC_telefonoTelefono
ON persona.Telefono(telefono);

CREATE NONCLUSTERED INDEX NC_productoNombre
ON catalogo.Producto(nombre)

CREATE NONCLUSTERED INDEX NC_compraFecha_compra
ON venta.Compra(fecha_compra)

-- DROP DATABASE PRUEBAS_PROYECTO_FINAL;
-- DROP DATABASE PROYECTO_FINAL_EQUIPO4_2022_2;

go
