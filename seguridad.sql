-- Proyecto FINAL Equipo 4
-- Script 'seguridad.sql' (DCL)
-- Semestre 2022-2

-- Hay 3 tipos de usuarios en la BD: Consulta, Gestor y Administrador
-- Se crearan 

-- Se crean usuarios con la siguiente sintaxis:
-- create login [nombreUsuario] with password = '[password]'
-- create user [nombreUsuario] for login [nombreUsuario]

-- USE PRUEBAS_PROYECTO_FINAL;
use PROYECTO_FINAL_EQUIPO4_2022_2;
GO

--Creación de los roles
CREATE ROLE invitado
go
CREATE ROLE cliente
go 
CREATE ROLE gestor 
go

--Creación de usuarioConsulta
CREATE LOGIN usuarioConsulta WITH PASSWORD = '1234zaq*', default_database =PRUEBAS_PROYECTO_FINAL,  CHECK_EXPIRATION=OFF
GO
CREATE USER usuarioConsulta FOR LOGIN usuarioConsulta 
go
ALTER ROLE invitado ADD member usuarioConsulta
go

--Creación de usuarioGestor
CREATE LOGIN usuarioGestor WITH PASSWORD = 'CaPx65*N', default_database =PRUEBAS_PROYECTO_FINAL,  CHECK_EXPIRATION=OFF
GO
CREATE USER usuarioGestor FOR LOGIN usuarioGestor 
go
ALTER ROLE gestor ADD member usuarioGestor
go

--Creación de usuarioAdministrador
CREATE LOGIN usuarioAdministrador WITH PASSWORD = 'FQzd94K&', default_database =PRUEBAS_PROYECTO_FINAL,  CHECK_EXPIRATION=OFF
GO
CREATE USER usuarioAdministrador FOR LOGIN usuarioAdministrador
go
ALTER ROLE gestor ADD member usuarioAdministrador
go

--Otorgar los procesos para las vistas
grant select on object ::venta.vi_cestasPropias to gestor
go
grant select on object ::catalogo.vi_detalleProducto to invitado, cliente
go
grant select on object ::catalogo.vi_mostrarProductos to invitado, cliente
go
grant select on object ::venta.vi_cestasPropias to cliente
go
grant select on object ::venta.vi_ventasGlobales to gestor
go
grant select on object ::venta.vi_ventasOnline to gestor
go
grant select on object ::venta.vi_ventasFisicas to gestor
go

--Otorgar los procesos para los procesos
grant execute on object ::venta.pa_cestasPropias to cliente
go
grant execute on object ::venta.pa_mostrarCestaActual to cliente
go
grant execute on object ::venta.pa_cestasPropias to gestor
go
grant execute on object ::venta.pa_mostrarCestaActual to cliente
go
grant execute on object ::venta.pa_mostrarTOTALCestaActual to cliente
go
grant execute on object ::catalogo.pa_mostrarProductos to invitado, cliente
go
grant execute on object ::catalogo.pa_detallesProductos to invitado,cliente
go
grant execute on object ::venta.pa_agregarACesta to cliente
go
grant execute on object ::venta.pa_eliminarProductosCesta to cliente
go
grant execute on object ::persona.pa_registrarComprador to invitado,gestor
go
grant execute on object ::persona.pa_registrarVendedor to gestor
go
grant execute on object ::persona.pa_registrarGestor to gestor
go
grant execute on object ::persona.pa_suscribirseAProducto to cliente
go
grant execute on object ::venta.pa_comprarCestaOnline to cliente
go 
grant execute on object ::venta.pa_comprarCestaFisica to cliente
go
grant execute on object ::venta.pa_cancelarCompra to cliente
go
grant execute on object ::catalogo.pa_actualizarStock to gestor
go

--Otorgar permisos para las estadisticas
grant execute on object ::venta.persona.pusuMayorVendedor to gestor
go
grant execute on object ::venta.pusuEpoca to gestor
go
grant execute on object ::venta.pusuMasComprado to gestor
go
grant execute on object ::venta.pusuTipoVentas to gestor
go

--Otorgar los derechos para los gestores
grant select, insert, update, delete on catalogo.Categoria to gestor
go
grant select, insert, update, delete on catalogo.Producto to gestor
go 
grant select, insert, update, delete on persona.Gestor to gestor
go
grant select, insert, update, delete on logistica.Oferta to gestor
go
grant alter any user to gestor 
go

--Verificar que el usuario este registrado e insertarlo como un user en la base de datos de acuerdo a su tipo
CREATE or ALTER PROCEDURE persona.pa_procSeguridad 
@username varchar(25)
AS
BEGIN
	DECLARE 
		@curp varchar(18),
		@usuario varchar(40),
		@contrasena varchar(30),
		@newUserCommand varchar(256),
		@newUserCommand2 varchar(256),
		@newUserCommand3 varchar(256)

	SELECT @usuario = username FROM persona.Usuario WHERE username=@username
	SELECT @contrasena = contrasena FROM persona.Usuario WHERE username=@username
	SELECT @curp = curp FROM persona.Usuario WHERE username=@username

	SET @newUserCommand = 'create login '+@usuario+' with password ='+@contrasena+',default_database = PROYECTO_FINAL_EQUIPO4_2022_2,  CHECK_EXPIRATION=OFF'
	EXECUTE (@newUserCommand)

	SET @newUserCommand2 = 'create user '+@usuario+' for login='+@usuario
	EXECUTE (@newUserCommand2)

	IF EXISTS(SELECT curp FROM persona.Usuario WHERE curp = @curp )
	BEGIN
		IF EXISTS(SELECT tipo_registrado FROM persona.Usuario WHERE tipo_registrado='C')
		BEGIN
			SET @newUserCommand3 = 'alter role cliente add member '+@usuario
			EXECUTE (@newUserCommand3)
		END
		ELSE IF EXISTS(SELECT tipo_registrado FROM persona.Usuario WHERE tipo_registrado='G')
		BEGIN
			SET @newUserCommand3 = 'alter role gestor add member '+@usuario
			EXECUTE (@newUserCommand3)
		END
	END
END
go

-- Trigger para crear el usuario en la BD al crear un usuario en la tabla BD
create or alter trigger persona.tr_creaUsuarioBD
ON persona.Usuario
AFTER INSERT
AS
BEGIN
	declare @v_username integer
	select @v_username = username from inserted
	EXECUTE persona.pa_procSeguridad @v_username;
END
GO

