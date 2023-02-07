-- DML | archivo: dml.sql
-- Proyecto BD

/*-----------------------------------------------------------
-------------------------DML---------------------------------
Fecha: 20/05/2022
Autor: Equipo 04: 
*/
-- use PRUEBAS_PROYECTO_FINAL;
use PROYECTO_FINAL_EQUIPO4_2022_2;
go


-- DML | archivo: dml.sql
-- Proyecto BD
--vista para visualizar todas las canastas de todos los usuarios, indicando los productos, costo y cantidad de los mismos

CREATE or ALTER VIEW venta.vi_cestasPropias as
	select c.id_usuario,c.id_cesta as NumCesta, p.nombre as Producto, cp.cantidad as Cantidad, 
			cp.cantidad*p.precio as Total from venta.Cesta c
	inner join venta.CestaProducto cp on c.id_cesta=cp.id_cesta --inner join por que solo tendremos registros de cestas con los productos que contienen
	inner join catalogo.Producto p on cp.clave=p.clave
go

-- Procedimiento para imprimir todas las cestas de un usuario, mostrando su numero, productos, para estos su cantidad y el costo total en cada uno. 
--Así como el costo total de la cesta
CREATE or ALTER PROCEDURE venta.pa_cestasPropias
	@p_idUsuario int
AS
BEGIN
	declare
		@v_idCesta int,
		@v_idCestaAux int,
		@v_nombre varchar(30),
		@v_cantidad int,
		@v_totalProd money,
		@v_totalCesta money=0
	DECLARE cCestas cursor --creamos un cursor para dar más formato a la impresion
	for select NumCesta,Producto,Cantidad, Total from venta.vi_cestasPropias
	where id_usuario=@p_idUsuario
	
	open cCestas
	fetch cCestas into @v_idCesta,@v_nombre,@v_cantidad,@v_totalProd
	select @v_idCestaAux=@v_idCesta
	while (@@FETCH_STATUS=0)
	begin
		print 'Cesta: '+cast(@v_idCesta as varchar)
		while (@v_idCesta=@v_idCestaAux and @@FETCH_STATUS=0) --la idea es que se muestre por bloques respecto a cada cesta, por eso que mientras que el cursor apunte a un registro de la misma cesta se mantiene
		begin
			print 'Producto '+@v_nombre+'   Cantidad: '+cast(@v_cantidad as varchar)+'   Total Producto: '+cast(@v_totalProd as varchar)
			select @v_totalCesta=@v_totalCesta+@v_totalProd
			select @v_idCestaAux=@v_idCesta --aquí la variable v_idCestaAux almacena el valor de la cesta "anterior"
			fetch cCestas into @v_idCesta,@v_nombre,@v_cantidad,@v_totalProd
		end
		print 'Total de Cesta: '+cast(@v_totalCesta as varchar)
		select @v_idCestaAux=@v_idCesta
		select @v_totalCesta=0
    --ya no es necesario usar un fetch afuera del while interno puesto que si sale de ese fue por que se desplazó el cursor a otra cesta o no hay más por leer.
	end
	close cCestas
	deallocate cCestas
END
GO

-- execute venta.pa_cestasPropias 0
-- go

-- Vista que contiene los detalles de los productos:
CREATE or alter VIEW catalogo.vi_detalleProducto as
	select p.clave,p.nombre as Producto, p.descripcion as Descripcion,p.descripcion_detallada as DescripcionDetallada,
	o.descripcion as DescripcionOferta, o.fecha_inicio as Inicio, o.fecha_fin as Fin from catalogo.Producto p
	left join logistica.OfertaProducto op on p.clave=op.clave
	left join logistica.Oferta o on op.id_oferta=o.id_oferta
go
--vista que enlista los productos, mostrando nombre y precio
CREATE or alter VIEW catalogo.vi_mostrarProductos as
	select p.clave,nombre,precio from catalogo.Producto p
go

-- Devuelve una tabla con el detalle de la cesta ingresada
create or alter FUNCTION venta.detalle_cesta(@p_idCesta INTEGER)
	RETURNS TABLE
	AS
	return select p.clave as 'Clave Producto',p.nombre as Producto, cp.cantidad as Cantidad, cp.cantidad*p.precio as Costo, 
			sum(cp.cantidad*p.precio) as Total from venta.Cesta c
	inner join venta.CestaProducto cp on c.id_cesta=cp.id_cesta
	inner join catalogo.Producto p on cp.clave=p.clave
	where c.id_cesta = @p_idCesta
	group by p.clave,c.id_cesta,p.nombre,cp.cantidad,cp.cantidad*p.precio;
go

-- SELECT * from venta.detalle_cesta(1);
-- go

-- Procedimiento para mostrar la cesta ACTIVA actual

CREATE or ALTER PROCEDURE venta.pa_mostrarCestaActual 
	@p_idUsuario INTEGER = NULL
AS
BEGIN
	-- Se verifica 
	if @p_idUsuario is null
	BEGIN
		-- Se obtiene el id Usuario del usuario logeado actual
		select @p_idUsuario=c.id_usuario from persona.Comprador as c
		inner join persona.Usuario as u
		on u.id_usuario=c.id_usuario
		where 
		u.username=CURRENT_USER 
	END
	if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
	begin
		-- Se obtiene el id de la cesta activa del usuario
		declare @v_idCesta INTEGER;
		SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
		-- Se verifica que se haya encontrado a la cesta
		if @v_idCesta is not null
		BEGIN
			SELECT * from venta.detalle_cesta(@v_idCesta);
		END
		else
			PRINT 'El usuario no cuenta con ninguna cesta activa'
	END
	ELSE
		print 'El usuario ingresado no se encuentra en la base de datos.'

END
go

-- Devuelve el total de la cesta ingresada 
create or alter FUNCTION venta.total_cesta_con_iva(@p_idCesta INTEGER)
	RETURNS money
	AS
	BEGIN
		declare @v_totalConIVA money
		declare @v_totalSinIVA money
		select @v_totalSinIVA= SUM(Total) from venta.detalle_cesta(@p_idCesta)
		set @v_totalConIVA = @v_totalSinIVA*0.16 + @v_totalSinIVA
		RETURN @v_totalConIVA;
	END
go

-- Procedimiento que muestra con un select el total parcial (Sin IVA) y el total con iva de la cesta actual
CREATE or ALTER PROCEDURE venta.pa_mostrarTOTALCestaActual 
	@p_idUsuario INTEGER = NULL
AS
BEGIN
	-- Se verifica 
	if @p_idUsuario is null
	BEGIN
		-- Se obtiene el id Usuario del usuario logeado actual
		select @p_idUsuario=c.id_usuario from persona.Comprador as c
		inner join persona.Usuario as u
		on u.id_usuario=c.id_usuario
		where 
		u.username=CURRENT_USER 
	END
	if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
	begin
		-- Se obtiene el id de la cesta activa del usuario
		declare @v_idCesta INTEGER;
		SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
		-- Se verifica que se haya encontrado a la cesta
		if @v_idCesta is not null
		BEGIN
			declare @v_subTotal money;
			SELECT @v_subTotal=SUM(Total) from venta.detalle_cesta(@v_idCesta);
			SELECT @v_subTotal as 'TOTAL de la cesta (sin IVA)', venta.total_cesta_con_iva (@v_idCesta) as 'Total con IVA'
		END
	END
	ELSE
		print 'El usuario ingresado no se encuentra en la base de datos.'

END
go

-- pa_mostrarProductos: muestra todos los productos existentes en tienda. Opera bajo la vista catalogo.vi_mostrarProductos
CREATE or alter PROCEDURE pa_mostrarProductos
AS
BEGIN
	select * from catalogo.vi_mostrarProductos
END
GO

--pa_detallesProductos: enlista un producto con sus detalles. Así mismo, muestra todas las fotos referentes al producto.
-- recibe como parámetro el id del producto a detallar. Puede ejecutarse este método para cada uno de los productos disponibles en tiendas.
CREATE or alter PROCEDURE pa_detallesProductos
	@v_clave int
AS
BEGIN
	select * from catalogo.vi_mostrarProductos where clave=@v_clave
	select imagen from logistica.Imagen where clave=@v_clave
END
GO

/*
Función busquedaProd. La función hace búsqueda cuyo producto sea similar en categoría, nombre, o descripción en ese orden. 
Los parámetros se distinguen entre nombre, categoría y descripción pues la función busca solo para una cada vez.
Las busquedas "globales" entre estos tres no están habilitados. El usuario puede "escoger" el parámetro sobre el que busca.
*/
CREATE or ALTER FUNCTION catalogo.busquedaProd(@p_nombre varchar(30),@p_categoria varchar(40), @p_descripcion varchar(50))
RETURNS @TablaProductos TABLE(clave int NULL, 
						nombre varchar(30) NULL,
						categoria varchar(40) NULL,
						precio money NULL,
						stock int NULL,
						mensaje varchar(50) NULL)
AS
BEGIN
	if (@p_categoria is not null or @p_nombre is not null or @p_descripcion is not null)
	begin
		if @p_categoria is not null --en jerarquía primero se busca en categoria, luego por nombre y por último por descripcion
		begin
			insert into @TablaProductos
			select clave, p.nombre, c.nombre, precio,stock,null
			from catalogo.Producto p 
			inner join catalogo.Categoria c on p.id_categoria=c.id_categoria
			where c.nombre like '%'+@p_categoria+'%' --el like con el % nos permite buscar  el patron entre todas las cadenas..
		end
		else if @p_nombre is not null
		begin
			insert into @TablaProductos
			select clave, p.nombre, c.nombre, precio,stock,null
			from catalogo.Producto p 
			inner join catalogo.Categoria c on p.id_categoria=c.id_categoria
			where p.nombre like '%'+@p_nombre+'%'
		end
		else
		begin
			insert into @TablaProductos
			select clave, p.nombre, c.nombre, precio,stock,null
			from catalogo.Producto p 
			inner join catalogo.Categoria c on p.id_categoria=c.id_categoria
			where p.descripcion like '%'+@p_descripcion+'%'
		end
	end
	else
	begin
		insert into @TablaProducto
		select null, null, null, null,null, 'Especifique al menos un valor no nulo para nombre, categoría o descripcion de producto para buscar' as Mensaje
	end
	return
END
go

/* Procedimiento para agregar productos a la cesta
* Funciona ingresando la clave del producto, o sin ingresarlo utilizando el nombre de usuario del usuario logeado
*/

CREATE or alter PROCEDURE venta.pa_agregarACesta
	@p_claveProducto INTEGER,
	@p_cantidad SMALLINT,
	@p_idUsuario INTEGER = NULL
AS
BEGIN
	if @p_cantidad > 0
	BEGIN
		-- Se verifica que el producto ingresado exista en la BD
		if exists(SELECT clave from catalogo.Producto where clave=@p_claveProducto)
		BEGIN
			declare @v_cantidadProductoActual SMALLINT;
			select @v_cantidadProductoActual=stock FROM catalogo.Producto where clave=@p_claveProducto;
			-- Se verifica que exista el stock suficiente para surtir al cliente
			if (@v_cantidadProductoActual-@p_cantidad >= 0 )
			BEGIN
				DECLARE @v_idCesta INTEGER;
				-- Si es null se utiliza el nombre de comprador actual
				if @p_idUsuario is null
				BEGIN
					-- Se obtiene el id Usuario del usuario logeado actual
					select @p_idUsuario=c.id_usuario from persona.Comprador as c
					inner join persona.Usuario as u
					on u.id_usuario=c.id_usuario
					where 
					u.username=CURRENT_USER 
					if @p_idUsuario is not null
					BEGIN
						-- Se obtiene el id de la cesta activa del usuario
						SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
						begin try
							INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
							VALUES (@v_idCesta,@p_claveProducto,@p_cantidad)

							PRINT 'Se agrego el producto a la cesta correctamente.'
						end TRY
						begin CATCH
							print 'ERROR: No se encuentra ninguna cesta activa para el usuario.'
						END CATCH
					end
					
					ELSE
						PRINT 'ERROR: El usuario actual no se encuentra registrado en la tabla Comprador'
				END
				-- Se verifica que el id de usuario ingresado exista
				else if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
				BEGIN
					-- Se obtiene el id de la cesta activa del usuario
					SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
					begin try
							INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
							VALUES (@v_idCesta,@p_claveProducto,@p_cantidad)

							PRINT 'Se agrego el producto a la cesta correctamente.'
						end TRY
						begin CATCH
							print 'ERROR: No se encuentra ninguna cesta activa para el usuario.'
						END CATCH

				END
				
				ELSE
					print 'El usuario ingresado no se encuentra en la base de datos.'
			END
			ELSE
				PRINT 'ERROR: No hay suficiente producto en stock para satisfacer la orden'
		END
		else
			PRINT 'ERROR: El producto ingresado no se encuentra en la base de datos'
	END
	ELSE
		PRINT 'ERROR: La cantidad debe ser mayor a 0.'
END
go

/*
Procedimiento venta.pa_eliminarProductosCesta: elimina todos los registros de venta.CestaProducto, "vaciando" la lista de la cesta
actual del cliente. Recibe como parámetro el idCesta. Esta se evalua que no sea null, así como que exista una cesta con tal id.
Se verifica pues que la cesta sea de tipo "Activa" (A) y si lo es elimina entonces los registros.
*/
CREATE or ALTER PROCEDURE venta.pa_eliminarProductosCesta
	@p_idCesta int 
AS
BEGIN
	declare
		@v_estado char(1)
	if @p_idCesta is not null --el id no es nulo
	begin
		if exists(select id_cesta from venta.Cesta where id_cesta=@p_idCesta) --evalua si existe una cesta con el id indicado
		begin
			select @v_estado=estado from venta.Cesta
			if @v_estado='A' --evalua si la cesta está en estado 'Activo'
			begin	
				delete from venta.CestaProducto where id_cesta=@p_idCesta
				Print 'Lista vaciada'
			end
			else
				Print 'Solo se permite eliminar productos de la cesta activa'
		end
		else
			Print 'No existe la cesta indicada'
	end
	else
		Print 'Ingrese un numero de cesta valido'
END
GO

-- select * from venta.Cesta where id_cesta=25
-- select * from venta.CestaProducto where id_cesta=25<<<<<<<<
-- go
-- execute venta.pa_eliminarProductosCesta 25
-- go

--procedimiento: venta.pa_eliminarProdCesta
-- Elimina el producto especificado de la cesta dada si ambos existen
CREATE or ALTER PROCEDURE venta.pa_eliminarProdCesta
	@p_idCesta int,
	@p_idProducto int
AS
BEGIN
	declare
		@v_estado char(1)
	if @p_idCesta is not null --el id no es nulo
	begin
		if exists(select id_cesta from venta.Cesta where id_cesta=@p_idCesta) --evalua si existe una cesta con el id indicado
		begin
			select @v_estado=estado from venta.Cesta
			if @v_estado='A' --evalua si la cesta está en estado 'Activo'
			begin	
				if(exists(select clave from venta.CestaProducto where clave=@p_idProducto and id_cesta=@p_idCesta))
				begin
					delete from venta.CestaProducto where id_cesta=@p_idCesta and clave=@p_idProducto
					Print 'Producto eliminado de cesta'
				end
				else
					Print 'No existe el producto en la cesta'
			end
			else
				Print 'Solo se permite eliminar productos de la cesta activa'
		end
		else
			Print 'No existe la cesta indicada'
	end
	else
		Print 'Ingrese un numero de cesta valido'
END
GO
-- insert into venta.CestaProducto values(1,5,1)
-- select * from venta.CestaProducto
-- exec venta.pa_eliminarProdCesta 1,5
-- go
/*
TRIGGER para notificar a los usuarios registrados sobre actualizaciones y ofertas a los productos suscritos
*/
CREATE or ALTER TRIGGER catalogo.tr_producNoti --para modificar debemos usar exactamente el mismo código con el que lo definimos:
ON catalogo.Producto
AFTER UPDATE
AS
	if (select precio from inserted)!=(select precio from deleted)
	begin
		declare @v_nombre varchar(90),
				@v_product varchar(30),
				@v_precio money
		DECLARE cSuscribe cursor
		for select u.nombre+' '+u.ap_paterno+' '+isnull(u.ap_materno,'') as nombre_completo,p.nombre,p.precio
		from persona.Usuario u
		inner join venta.Suscribe s on u.id_usuario=s.id_usuario
		inner join catalogo.Producto p on s.clave=p.clave
		where p.clave=(select clave from inserted)
		open cSuscribe
		fetch cSuscribe into @v_nombre,@v_product,@v_precio
		while (@@FETCH_STATUS=0)
		begin
			print 'Usuario '+@v_nombre+' a sido notificado del cambio de precio del producto '+@v_product+' a '+cast(@v_precio as varchar)+' pesos'
			fetch cSuscribe into @v_nombre,@v_product,@v_precio
		end
		close cSuscribe
		deallocate cSuscribe
	end
go
/*
TRIGGER catalogo.tr_ofertaNoti: notifica a los usuarios suscritos si hubo una oferta registrada para el producto
*/
CREATE or ALTER TRIGGER logistica.tr_ofertaNoti --para modificar debemos usar exactamente el mismo código con el que lo definimos:
ON logistica.OfertaProducto
AFTER INSERT, UPDATE --update por que puede "corregirse" una oferta y el producto asignarse a esta, por lo que también notificaría al user
AS
BEGIN
	declare @v_nombre varchar(90),
			@v_product varchar(30),
			@v_descripcion varchar(50)
	DECLARE cOfertaSuscrito cursor
	for select u.nombre+' '+u.ap_paterno+' '+isnull(u.ap_materno,'') as nombre_completo,p.nombre, o.descripcion
	from persona.Usuario u
	inner join venta.Suscribe s on u.id_usuario=s.id_usuario
	inner join catalogo.Producto p on s.clave=p.clave
	inner join logistica.OfertaProducto op on p.clave=op.clave
	inner join logistica.Oferta	o on op.id_oferta=o.id_oferta
	where p.clave=(select clave from inserted) and o.id_oferta=(select id_oferta from inserted)

	open cOfertaSuscrito
	fetch cOfertaSuscrito into @v_nombre,@v_product,@v_descripcion
	while (@@FETCH_STATUS=0)
	begin
		print 'Usuario '+@v_nombre+' a sido notificado de nueva oferta del producto '+@v_product+': '+@v_descripcion
		fetch cOfertaSuscrito into @v_nombre,@v_product,@v_descripcion
	end
	close cOfertaSuscrito
	deallocate cOfertaSuscrito
END
go
-- select * from catalogo.Producto
-- select * from logistica.Oferta
-- insert into logistica.OfertaProducto(id_oferta,clave)
-- values (0,0)
-- select * from logistica.OfertaProducto
-- SELECT * FROM venta.Suscribe
-- go

/* PROCEDIMIENTOS ALMACENADOS ------------------------------- */

-- PROCEDIMIENTO REGISTRO USUARIOS ------------

CREATE or alter PROCEDURE persona.pa_registrarComprador
	@p_nombre VARCHAR(40),
	@p_paterno VARCHAR(40),
	@p_materno VARCHAR(40),
    @p_username VARCHAR(25),
    @p_curp VARCHAR(18),
    @p_contrasena VARCHAR(30),
    @p_genero CHAR(1),
    @p_fechaNacimiento DATE,
    @p_email VARCHAR(40),
	-- Valores domicilio
	@p_calle VARCHAR(40),
	@p_acaldia VARCHAR(40),
	@p_nInterior TINYINT,
	@p_colonia VARCHAR(40),
	@p_nExterior TINYINT,
	-- Valores telefono
	@p_telefono INTEGER
AS
BEGIN
	if @p_nombre is null or @p_paterno is null or @p_username is null or @p_curp is null or @p_contrasena is null or @p_genero is null or @p_fechaNacimiento is null or     @p_email is null or  @p_calle is null or @p_acaldia is null or @p_colonia is null or @p_nExterior is null or @p_telefono is null
		print' ERROR: Ingresa un valor para nombre, paterno, username, curp, contraseña, genero, fechaNacimiento y/o email. Estos valores NO pueden ser NULL.'
	else if not @p_genero in ('H','M')
        print 'ERROR: El genero debe ser H (Hombre) o M (Mujer).'
    else if exists(select contrasena from persona.Usuario where contrasena = @p_contrasena)
        print 'ERROR: La contraseña YA EXISTE.'
    else if (DATALENGTH(@p_contrasena) < 8)
        print 'ERROR: La contraseña es menor a 8 caracteres.'
    else if exists(select username from persona.Usuario where username = @p_username)
        print 'ERROR: El nombre de usuario YA EXISTE.'
    else if exists(select curp from persona.Usuario where curp = @p_curp)
        print 'ERROR: El CURP ya esta registrado.'
    else if (DATALENGTH(@p_curp) != 18)
        print 'ERROR: El CURP es menor a 18 caracteres.'
    else if exists(select email from persona.Usuario where email = @p_email)
        print 'ERROR: El correo electronico (email) ya esta registrado.'
    else if ((CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@p_fechaNacimiento,112))/10000 <= 18)
        PRINT 'ERROR: El usuario debe tener al menos 18 años.'
	else
        BEGIN
			begin TRY
				INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,curp,contrasena,genero, fecha_nacimiento,email,tipo_registrado) VALUES (@p_nombre,	@p_paterno,	@p_materno, @p_username, @p_curp, @p_contrasena,     @p_genero, @p_fechaNacimiento,@p_email,'C')
				declare @v_id INTEGER;
				SELECT @v_id=id_usuario from persona.Usuario where username=@p_username
				insert into persona.Domicilio(calle,alcaldia,colonia,num_exterior,num_interior,id_usuario) VALUES (@p_calle,@p_acaldia,@p_colonia,@p_nExterior,@p_nInterior,@v_id)
				insert into persona.Telefono(id_usuario,telefono) VALUES(@v_id,@p_telefono)
				insert into persona.Comprador VALUES(@v_id)
				PRINT 'Comprador registrado correctamente'
			END TRY
			BEGIN CATCH
				PRINT 'Se produjo un error al insertar al comprador. Verfica tus datos e intentalo de nuevo.'
			END CATCH
        end
END
go

CREATE or alter PROCEDURE persona.pa_registrarVendedor
	@p_nombre VARCHAR(40),
	@p_paterno VARCHAR(40),
	@p_materno VARCHAR(40),
    @p_username VARCHAR(25),
    @p_curp VARCHAR(18),
    @p_contrasena VARCHAR(30),
    @p_genero CHAR(1),
    @p_fechaNacimiento DATE,
    @p_email VARCHAR(40),
    @p_sueldo MONEY,
	-- Valores domicilio
	@p_calle VARCHAR(40),
	@p_acaldia VARCHAR(40),
	@p_nInterior TINYINT,
	@p_colonia VARCHAR(40),
	@p_nExterior TINYINT,
	-- Valores telefono
	@p_telefono INTEGER
AS
BEGIN
	if @p_nombre is null or @p_paterno is null or @p_username is null or @p_curp is null or @p_contrasena is null or @p_genero is null or @p_fechaNacimiento is null or     @p_email is null or @p_calle is null or @p_acaldia is null or @p_colonia is null or @p_nExterior is null or @p_telefono is null
		print 'ERROR: Ingresa un valor para nombre, paterno, username, curp, contraseña, genero, fechaNacimiento y/o email. Estos valores NO pueden ser NULL.'
	else if not @p_genero in ('H','M')
        print 'ERROR: El genero debe ser H (Hombre) o M (Mujer).'
    else if exists(select contrasena from persona.Usuario where contrasena = @p_contrasena)
        print 'ERROR: La contraseña YA EXISTE.'
    else if (DATALENGTH(@p_contrasena) < 8)
        print 'ERROR: La contraseña es menor a 8 caracteres.'
    else if exists(select username from persona.Usuario where username = @p_username)
        print 'ERROR: El nombre de usuario YA EXISTE.'
    else if exists(select curp from persona.Usuario where curp = @p_curp)
        print 'ERROR: El CURP ya esta registrado.'
    else if (DATALENGTH(@p_curp) != 18)
        print 'ERROR: El CURP es menor a 18 caracteres.'
    else if exists(select email from persona.Usuario where email = @p_email)
        print 'ERROR: El correo electronico (email) ya esta registrado.'
    else if ((CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@p_fechaNacimiento,112))/10000 <= 18)
        PRINT 'ERROR: El usuario debe tener al menos 18 años.'
    else if @p_sueldo < 5000
		PRINT 'ERROR: El sueldo no puede ser menor a $5000.00'
	else
	BEGIN
        BEGIN TRY
            INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,curp,contrasena,genero, fecha_nacimiento,email,tipo_registrado) VALUES (@p_nombre,	@p_paterno,	@p_materno, @p_username, @p_curp, @p_contrasena,     @p_genero, @p_fechaNacimiento,@p_email,'V')
			declare @v_id INTEGER;
			SELECT @v_id=id_usuario from persona.Usuario where username=@p_username
			INSERT INTO persona.Vendedor(id_usuario,sueldo) VALUES
			(@v_id,@p_sueldo)
			insert into persona.Domicilio(calle,alcaldia,colonia,num_exterior,num_interior,id_usuario) VALUES (@p_calle,@p_acaldia,@p_colonia,@p_nExterior,@p_nInterior,@v_id)
				insert into persona.Telefono(id_usuario,telefono) VALUES(@v_id,@p_telefono)
			PRINT 'Vendedor registrado correctamente'
        end TRY
		BEGIN CATCH
			PRINT 'Se produjo un error al registrar al vendedor. Verifica tus datos e intentalo de nuevo'
		END CATCH
	END
END
GO

CREATE or alter PROCEDURE persona.pa_registrarGestor
	@p_nombre VARCHAR(40),
	@p_paterno VARCHAR(40),
	@p_materno VARCHAR(40),
    @p_username VARCHAR(25),
    @p_curp VARCHAR(18),
    @p_contrasena VARCHAR(30),
    @p_genero CHAR(1),
    @p_fechaNacimiento DATE,
    @p_email VARCHAR(40),
	@p_idSupervisor INTEGER,
	-- Valores domicilio
	@p_calle VARCHAR(40),
	@p_acaldia VARCHAR(40),
	@p_nInterior TINYINT,
	@p_colonia VARCHAR(40),
	@p_nExterior TINYINT,
	-- Valores telefono
	@p_telefono INTEGER
AS
BEGIN
	if @p_nombre is null or @p_paterno is null or @p_username is null or @p_curp is null or @p_contrasena is null or @p_genero is null or @p_fechaNacimiento is null or     @p_email is null or @p_calle is null or @p_acaldia is null or @p_colonia is null or @p_nExterior is null or @p_telefono is null
		print 'ERROR: Ingresa un valor para nombre, paterno, username, curp, contraseña, genero, fechaNacimiento y/o email. Estos valores NO pueden ser NULL.'
	else if not @p_genero in ('H','M')
        print 'ERROR: El genero debe ser H (Hombre) o M (Mujer).'
    else if exists(select contrasena from persona.Usuario where contrasena = @p_contrasena)
        print 'ERROR: La contraseña YA EXISTE.'
    else if (DATALENGTH(@p_contrasena) < 8)
        print 'ERROR: La contraseña es menor a 8 caracteres.'
    else if exists(select username from persona.Usuario where username = @p_username)
        print 'ERROR: El nombre de usuario YA EXISTE.'
    else if exists(select curp from persona.Usuario where curp = @p_curp)
        print 'ERROR: El CURP ya esta registrado.'
    else if (DATALENGTH(@p_curp) != 18)
        print 'ERROR: El CURP es menor a 18 caracteres.'
    else if exists(select email from persona.Usuario where email = @p_email)
        print 'ERROR: El correo electronico (email) ya esta registrado.'
    else if ((CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@p_fechaNacimiento,112))/10000 <= 18)
        PRINT 'ERROR: El usuario debe tener al menos 18 años.'
    else if not exists(select id_usuario from persona.Gestor where id_usuario=@p_idSupervisor) and @p_idSupervisor is not null
		print 'ERROR: El id del supervisor no esta registrado.'
	else
	BEGIN
        BEGIN try
            INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,curp,contrasena,genero, fecha_nacimiento,email,tipo_registrado) VALUES (@p_nombre,	@p_paterno,	@p_materno, @p_username, @p_curp, @p_contrasena,     @p_genero, @p_fechaNacimiento,@p_email,'G')

			declare @v_id INTEGER;
			SELECT @v_id=id_usuario from persona.Usuario where username=@p_username

			INSERT into persona.Gestor(id_usuario,supervisor_gestor) VALUES (@v_id,@p_idSupervisor)
			insert into persona.Domicilio(calle,alcaldia,colonia,num_exterior,num_interior,id_usuario) VALUES (@p_calle,@p_acaldia,@p_colonia,@p_nExterior,@p_nInterior,@v_id)
				insert into persona.Telefono(id_usuario,telefono) VALUES(@v_id,@p_telefono)

			PRINT 'Gestor registrado correctamente'
        end TRY
		BEGIN CATCH
			PRINT 'Se produjo un error al registrar al gestor. Verifica tus datos e intentalo de nuevo'
		END CATCH
	END
END
GO

-- Procedimiento para 'meter' a la cesta un producto
-- Funciona ingresando la clave del producto, o sin ingresarlo utilizando el nombre de usuario del usuario logeado

CREATE or alter PROCEDURE persona.pa_suscribirseAProducto
	@p_claveProducto INTEGER,
	@p_idUsuario INTEGER = NULL
as
BEGIN
	if exists(select nombre from catalogo.Producto where clave=@p_claveProducto)
	BEGIN
		-- Si es null se utiliza el nombre de usuario actual
		if @p_idUsuario is null
		BEGIN
			-- Se obtiene el id Usuario del comprador logeado actual hacendo un join con la tabla usuario
			select @p_idUsuario=c.id_usuario from persona.Comprador as c
			inner join persona.Usuario as u
			on u.id_usuario=c.id_usuario
			where 
			u.username=CURRENT_USER
			if @p_idUsuario is not null
			BEGIN
				INSERT into venta.Suscribe(id_usuario,clave) VALUES (@p_idUsuario,@p_claveProducto)
				PRINT 'Suscripcion realizada correctamente.'
			END
			ELSE
				PRINT 'ERROR: El usuario actual no se encuentra registrado en la tabla Comprador'

		END
		-- Se verifica que el id de usuario ingresado exista en la tabla Comprador
		else if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
		BEGIN
			INSERT into venta.Suscribe(id_usuario,clave) VALUES (@p_idUsuario,@p_claveProducto)
			PRINT 'Suscripcion realizada correctamente.'
		END
		
		ELSE
			print 'El usuario ingresado no se encuentra en la base de datos.'
	END 
	else
		PRINT 'ERROR: La clave de producto ingresada no se encuentra registrada en la BD.'
END
go

-- EXECUTE persona.pa_suscribirseAProducto 0,0
go

-- Trigger para que cada que se cree un COMPRADOR, se cree una cesta ACTIVA

create or alter trigger persona.tr_crearCesta
on persona.Comprador
after insert
AS
BEGIN
	declare @v_idUsuario integer;
	select @v_idUsuario= id_usuario from inserted;
    INSERT into venta.Cesta(id_usuario,estado) VALUES
	(@v_idUsuario,'A')
end
GO

-- Trigger para que cada que se intente crear una cesta para un usuario se verifique si no existe ya una cesta activa

create or alter trigger venta.tr_verificaCestaActiva
on venta.Cesta
instead of insert
AS
BEGIN
	declare @v_idUsuario integer,@v_estado char(1),@v_fRegistro DATE;
	SELECT @v_idUsuario=id_usuario, @v_estado=estado,@v_fRegistro=fecha_registro from inserted;

	-- Si se esta intentando de ingresar una cesta activa...
	if @v_estado = 'A'
	BEGIN
		-- Se verifica que el comprador NO cuente con una cesta activa
		if not exists(select id_cesta FROM venta.Cesta
		where id_usuario=@v_idUsuario and estado='A')
		BEGIN
			INSERT into venta.Cesta(id_usuario,estado) VALUES
			(@v_idUsuario,'A')
		END
		else
			PRINT 'ERROR: No se ha podido crear una cesta para el usuario debido a que este ya cuenta con una cesta ACTIVA'
	END
	-- Se esta insertando un historial de cestas
	ELSE
	BEGIN
		INSERT into venta.Cesta(id_usuario,estado,fecha_registro) VALUES
			(@v_idUsuario,@v_estado,@v_fRegistro)
	END
end
GO


-- Funcion obtener total de una cesta
create or alter function venta.obtenerTotalCesta(@p_idCesta integer)
    returns money
    as
    begin
        declare @v_total money
		select @v_total= SUM(Total) from venta.detalle_cesta(@p_idCesta)
		return @v_total
	end;
go

-- Procedimiento para 'comprar' una cesta

CREATE or alter PROCEDURE venta.pa_comprarCestaOnline
	@p_idUsuario INTEGER = NULL,
	@p_medioEnvio INTEGER -- 1 -> Terrestre, 2 -> Aereo, 3 -> Maritimo
AS
BEGIN
	-- Se verifica 
	if @p_idUsuario is null
	BEGIN
		-- Se obtiene el id Usuario del usuario logeado actual
		select @p_idUsuario=c.id_usuario from persona.Comprador as c
		inner join persona.Usuario as u
		on u.id_usuario=c.id_usuario
		where 
		u.username=CURRENT_USER 
	END
	if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
	begin
		-- Se obtiene el id de la cesta activa del usuario
		declare @v_idCesta INTEGER;
		SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
		-- Se verifica que se haya encontrado a la cesta y la cesta tiene productos
		if @v_idCesta is not null and exists(select clave from venta.CestaProducto where id_cesta=@v_idCesta)
		BEGIN
			declare @v_banderaError INTEGER, @v_producto VARCHAR(30),@v_cantidad smallint, @v_claveProducto INTEGER
			set @v_banderaError = 0;
			declare @v_cantidadProductoActual SMALLINT;
			-- Se verifica que haya suficiente stock para satisfacer la solicitud del cliente
			declare cDetalleCesta cursor READ_ONLY
			for select Producto,Cantidad,[Clave Producto] from venta.detalle_cesta(@p_idUsuario);

			open cDetalleCesta
				FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
				WHILE @@FETCH_STATUS = 0 and @v_banderaError = 0
				BEGIN
					select @v_cantidadProductoActual=stock FROM catalogo.Producto where clave=@v_claveProducto;

					-- Se verifica que exista el stock suficiente para surtir al cliente
					if not (@v_cantidadProductoActual-@v_cantidad >= 0 )
						set @v_banderaError = 1
					ELSE
						FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
				END
			CLOSE cDetalleCesta
			DEALLOCATE cDetalleCesta

			if @v_banderaError = 1
				PRINT 'ERROR: El producto ' + @v_producto + ' no tiene stock suficiente para satisfacer la compra'
			-- Si hay stock para TODOS los productos:
			else
			BEGIN
				-- Insert en tabla compra
				Insert into venta.Compra(id_cesta,tipo_compra,iva,monto_total,id_medio) VALUES (@v_idCesta,'L',venta.obtenerTotalCesta(@v_idCesta)*.16,venta.total_cesta_con_iva(@v_idCesta),@p_medioEnvio)
				-- Moficar la cesta actual y colocar el estado como 'C' (Comprado)
				UPDATE venta.Cesta
				SET estado='C'
				WHERE id_cesta=@v_idCesta;
				-- Se actualiza el stock en los productos
				declare cDetalleCesta cursor READ_ONLY
				for select Producto,Cantidad,[Clave Producto] from venta.detalle_cesta(@p_idUsuario);
				open cDetalleCesta
					FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
					WHILE @@FETCH_STATUS = 0 and @v_banderaError = 0
					BEGIN
						select @v_cantidadProductoActual=stock FROM catalogo.Producto where clave=@v_claveProducto;
						update catalogo.Producto
						set stock=@v_cantidadProductoActual-@v_cantidad
						where clave=@v_claveProducto;
						
						FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
					END
				CLOSE cDetalleCesta
				DEALLOCATE cDetalleCesta

				-- Se inserta en la tabla 'En linea' 
				declare @v_sistemaTransporte VARCHAR(40), @v_otro VARCHAR(40)
				set @v_sistemaTransporte =case @p_medioEnvio
						when 1 then 'Paquete enviado mediante Correos de mexico'
						when 2 then 'Paquete enviado mediante DHL'
						when 3 then 'Paquete enviado mediante Submarino'
						-- Si se llega a agregar otro tipo de medio y no se agrega en este trigger se coloca el nombre del medio de envio
						else  (select medio from logistica.MedioEnvio where id_medio=@p_medioEnvio)
					end -- case
				INSERT into venta.EnLinea(id_compra,sistema_transporte) VALUES((select id_compra from venta.Compra where id_cesta= @v_idCesta),@v_sistemaTransporte)
				-- Crear una nueva cesta activa vacia para el cliente
				INSERT INTO venta.Cesta(id_usuario,estado) VALUES(@p_idUsuario,'A')
				PRINT 'Cesta comprada exitosamente'
			END
		END
		ELSE
				PRINT 'ERROR: La cesta esta VACIA'
	END
	ELSE
		print 'ERROR: El usuario ingresado no se encuentra en la base de datos.'
END
go


-- Procedimiento para comprar una cesta de forma fisica, indicando el id del usuario y el id del vendedor

CREATE or alter PROCEDURE venta.pa_comprarCestaFisica
	@p_idUsuario INTEGER = NULL,
	@p_idVendedor INTEGER 
AS
BEGIN
	-- Se verifica que exista el vendedor ingresado
	if exists(select id_usuario from persona.Vendedor where id_usuario=@p_idVendedor )
	BEGIN
		-- Se verifica 
		if @p_idUsuario is null
		BEGIN
			-- Se obtiene el id Usuario del comprador logeado actual
			select @p_idUsuario=c.id_usuario from persona.Comprador as c
			inner join persona.Usuario as u
			on u.id_usuario=c.id_usuario
			where 
			u.username=CURRENT_USER 
		END
		if exists(select id_usuario FROM persona.Comprador where id_usuario=@p_idUsuario)
		begin
			-- Se obtiene el id de la cesta activa del usuario
			declare @v_idCesta INTEGER;
			SELECT @v_idCesta = id_cesta from venta.Cesta where id_usuario=@p_idUsuario and estado='A'
			-- Se verifica que se haya encontrado a la cesta y que tenga productos
			if @v_idCesta is not null and exists(select clave from venta.CestaProducto where id_cesta=@v_idCesta)
			BEGIN
				declare @v_banderaError INTEGER, @v_producto VARCHAR(30),@v_cantidad smallint, @v_claveProducto INTEGER
				set @v_banderaError = 0;
				declare @v_cantidadProductoActual SMALLINT;
				-- Se verifica que haya suficiente stock para satisfacer la solicitud del cliente
				declare cDetalleCesta cursor READ_ONLY
				for select Producto,Cantidad,[Clave Producto] from venta.detalle_cesta(@p_idUsuario);

				open cDetalleCesta
					FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
					WHILE @@FETCH_STATUS = 0 and @v_banderaError = 0
					BEGIN
						select @v_cantidadProductoActual=stock FROM catalogo.Producto where clave=@v_claveProducto;

						-- Se verifica que exista el stock suficiente para surtir al cliente
						if not (@v_cantidadProductoActual-@v_cantidad >= 0 )
							set @v_banderaError = 1
						ELSE
							FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
					END
				CLOSE cDetalleCesta
				DEALLOCATE cDetalleCesta

				if @v_banderaError = 1
					PRINT 'ERROR: El producto ' + @v_producto + ' no tiene stock suficiente para satisfacer la compra'
				-- Si hay stock para TODOS los productos:
				else
				BEGIN
					-- Insert en tabla compra
					Insert into venta.Compra(id_cesta,tipo_compra,iva,monto_total,id_medio) VALUES (@v_idCesta,'L',venta.obtenerTotalCesta(@v_idCesta)*.16,venta.total_cesta_con_iva(@v_idCesta),1)
					-- Se actualiza el stock en los productos
					declare cDetalleCesta cursor READ_ONLY
					for select Producto,Cantidad,[Clave Producto] from venta.detalle_cesta(@p_idUsuario);
					open cDetalleCesta
						FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
						WHILE @@FETCH_STATUS = 0 and @v_banderaError = 0
						BEGIN
							select @v_cantidadProductoActual=stock FROM catalogo.Producto where clave=@v_claveProducto;
							update catalogo.Producto
							set stock=@v_cantidadProductoActual-@v_cantidad
							where clave=@v_claveProducto;
							
							FETCH NEXT from cDetalleCesta into @v_producto, @v_cantidad,@v_claveProducto;
						END
					CLOSE cDetalleCesta
					DEALLOCATE cDetalleCesta

					-- Moficar la cesta actual y colocar el estado como 'C' (Comprado)
					UPDATE venta.Cesta
					SET estado='C'
					WHERE id_cesta=@v_idCesta;
					
					-- Se inserta en la tabla 'Fisica' 
					INSERT into venta.Fisica(id_compra,id_usuario) VALUES((select id_compra from venta.Compra where id_cesta= @v_idCesta),@p_idVendedor)
					-- Crear una nueva cesta activa vacia para el cliente
					INSERT INTO venta.Cesta(id_usuario,estado) VALUES(@p_idUsuario,'A')
					PRINT 'Cesta comprada exitosamente'
				END
			END
			ELSE
				PRINT 'ERROR: La cesta esta VACIA'
		END
		ELSE
			print 'ERROR: El usuario ingresado no se encuentra en la base de datos.'
	end

	ELSE
		PRINT 'ERROR: El vendedor ingresado no se encuentra en la base de datos'
	
END
go

-- Procedimiento para eliminar compra
CREATE or ALTER PROCEDURE venta.pa_cancelarCompra
	@p_idCompra int
AS
BEGIN
	declare
		@v_idCesta int,
		@v_tiempo int
	if(@p_idCompra is not null)
	begin
		if(exists(select * from venta.Compra where id_compra=@p_idCompra))
		begin
			if (datediff ( hh, (select fecha_compra from venta.Compra),GETDATE())<48)
			begin
				select @v_idCesta=id_cesta from venta.Compra
				delete from venta.Compra where id_compra=@p_idCompra
				update venta.Cesta set
					estado='E'
				where id_cesta=@v_idCesta
			end
			else
				Print 'El tiempo límite de cancelacion (48 hrs) terminó'
		end
	end
	DEALLOCATE cDetalleCesta
END
GO

-- Procedimiento para actualizar el producto

CREATE or alter PROCEDURE catalogo.pa_actualizarStock
	@p_claveProducto INTEGER,
	@p_nuevoStock SMALLINT
AS
BEGIN
	if @p_nuevoStock > 0
	BEGIN
		IF exists(select stock from catalogo.Producto where clave=@p_claveProducto)
		BEGIN
			UPDATE catalogo.Producto
			set stock = stock + @p_nuevoStock
			where clave = @p_claveProducto
			print 'El stock fue actualizado correctamente.'
		END
		else
			PRINT 'ERROR: El producto no esta registrado no esta.'
	end
	ELSE
		print 'ERROR: El nuevo stock no puede ser 0.'
	
END
GO

-- select stock from catalogo.Producto where clave=1
-- EXECUTE catalogo.pa_actualizarStock 1,2
-- select stock from catalogo.Producto where clave=1

-- Trigger validar que el usuario ingresado a Vendedor si sea
create or alter TRIGGER persona.tr_validaVendedor
ON persona.Vendedor
instead of insert
AS
begin
	declare @v_idUsuario INTEGER, @v_tipoUsuario CHAR(1),@v_sueldo money
	SELECT @v_idUsuario=id_usuario,@v_sueldo=sueldo from inserted;
	select @v_tipoUsuario=tipo_registrado from persona.Usuario
	where id_usuario=@v_idUsuario;
	if @v_tipoUsuario = 'V'
		insert into persona.Vendedor(id_usuario,sueldo) values(@v_idUsuario,@v_sueldo)
	ELSE
		print 'ERROR: El usuario ingresado no es un Vendedor'
end
go
-- Trigger validar que el usuario ingresado a Gestor si sea GEstor
create or alter TRIGGER persona.tr_validaGestor
ON persona.Gestor
instead of insert
AS
begin
	declare @v_idUsuario INTEGER, @v_tipoUsuario CHAR(1),@v_idSupervisor INTEGER
	SELECT @v_idUsuario=id_usuario,@v_idSupervisor=supervisor_gestor from inserted;
	select @v_tipoUsuario=tipo_registrado from persona.Usuario
	where id_usuario=@v_idUsuario;;
	if @v_tipoUsuario = 'G'
		insert into persona.Gestor(id_usuario,supervisor_gestor) values(@v_idUsuario,@v_idSupervisor)
	ELSE
		print 'ERROR: El usuario ingresado no es un Gestor'
end
go
-- Trigger validar que el usuario ingresado a Comprador si sea
create or alter TRIGGER persona.tr_validaComprador
ON persona.Comprador
instead of insert
AS
begin
	declare @v_idUsuario INTEGER, @v_tipoUsuario CHAR(1)
	SELECT @v_idUsuario=id_usuario from inserted;
	select @v_tipoUsuario=tipo_registrado from persona.Usuario
	where id_usuario=@v_idUsuario;
	if @v_tipoUsuario = 'C'
		insert into persona.Comprador(id_usuario) values(@v_idUsuario)
	ELSE
		print 'ERROR: El usuario ingresado no es un Comprador'
end
go

-- insert into persona.Comprador (id_usuario) VALUES(1)
-- select * from persona.Comprador
-- go
-- Vista de ventas (globales)

create or alter VIEW venta.vi_ventasGlobales
as
	select p.nombre as 'Producto', cp.cantidad, c.fecha_compra as 'Fecha Compra', cantidad*p.precio as 'Costo (sin iva)'
	from venta.Compra as c
	inner join venta.Cesta as ces
	on c.id_cesta=ces.id_cesta
	inner join venta.CestaProducto as cp
	on ces.id_cesta=cp.id_cesta
	inner join catalogo.Producto as p
	on p.clave = cp.clave
go

create or alter VIEW venta.vi_ventasOnline
as
	select p.nombre as 'Producto', cp.cantidad, c.fecha_compra as 'Fecha Compra', cantidad*p.precio as 'Costo (sin iva)'
	from venta.Compra as c
	inner join venta.Cesta as ces
	on c.id_cesta=ces.id_cesta
	inner join venta.CestaProducto as cp
	on ces.id_cesta=cp.id_cesta
	inner join catalogo.Producto as p
	on p.clave = cp.clave
	where tipo_compra='L'
go

create or alter VIEW venta.vi_ventasFisicas
as
	select p.nombre as 'Producto', cp.cantidad, c.fecha_compra as 'Fecha Compra', cantidad*p.precio as 'Costo (sin iva)'
	from venta.Compra as c
	inner join venta.Cesta as ces
	on c.id_cesta=ces.id_cesta
	inner join venta.CestaProducto as cp
	on ces.id_cesta=cp.id_cesta
	inner join catalogo.Producto as p
	on p.clave = cp.clave
	where tipo_compra='F'
go

-- SELECT * from venta.vi_ventasGlobales
-- SELECT * from venta.vi_ventasOnline
-- SELECT * from venta.vi_ventasFisicas

-- pa_cambiarCesta: permite cambiar la cesta activa por alguna cesta registrada previamente
CREATE or ALTER PROCEDURE pa_cambiarCesta
	@p_idCesta int
as
begin
	declare @v_idCesta int,
		@v_idCliente int
	if(@p_idCesta is not null)
	begin
		if(exists(select id_cesta from venta.Cesta where id_cesta=@p_idCesta))
		begin
			if exists(select id_cesta from venta.Cesta where id_cesta=@p_idCesta and estado='C')
			begin
				select @v_idCliente=id_usuario from venta.Cesta where id_cesta=@p_idCesta
				select @v_idCesta=id_cesta from venta.Cesta where id_usuario=@v_idCliente and estado='A'
				update venta.Cesta set
					estado='E'
				where id_cesta=@v_idCesta
				update venta.Cesta set
					estado='A'
				where id_cesta=@p_idCesta
				Print 'Cesta Cambiada'
			end
			else
				Print 'La cesta indicada no es váldia para la selección'
		end
		else
			Print 'No existe la cesta indicada'
	end
	else
		Print 'Debe ingresar un valor no nulo de cesta'
end

select * from venta.Cesta where id_usuario=1
exec pa_cambiarCesta 11
go

-- trigger para los 15 dias de la cesta
create or alter TRIGGER venta.tr_tiempoCesta
on venta.CestaProducto
instead of insert
AS
BEGIN
	declare @v_idCesta INTEGER,@v_clave INTEGER, @v_cantidad SMALLINT, @v_fechaCreacion DATE
	SELECT @v_idCesta = id_cesta,@v_clave=clave,@v_cantidad = cantidad from inserted

	if exists(SELECT id_cesta from venta.Cesta where id_cesta=@v_idCesta)
	BEGIN
		SELECT @v_fechaCreacion =fecha_registro  from venta.Cesta where id_cesta=@v_idCesta
		if DATEDIFF ( DAY , @v_fechaCreacion , GETDATE() ) < 15
		BEGIN
			INSERT INTO venta.CestaProducto(id_cesta,clave,cantidad) VALUES (@v_idCesta,@v_clave,@v_cantidad)
		END
		-- Si tiene mas de 15 dias se elimina la cesta
		else
			EXECUTE venta.pa_eliminarProductosCesta @v_idCesta
	END
	ELSE
		PRINT 'ERROR: La cesta ingresada no existe'
END
