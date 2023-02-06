-- Estadisticas (informes.sql):
-- Proyecto final BD

use PROYECTO_FINAL_EQUIPO4_2022_2;
go

-- 1.  qué vendedor realiza más ventas en un periodo de tiempo
create or alter procedure persona.pusuMayorVendedor

as
begin
	declare @v_fechaMinima datetime,
					@v_mes	datetime,
					@v_fechaMaxima datetime
	select @v_fechaMinima = (select min(fecha_compra) from venta.Compra c
						inner join venta.Fisica f on c.id_compra=f.id_compra)
	-- fecha maxima
	select @v_fechaMaxima = (select max(fecha_compra) from venta.Compra c
						inner join venta.Fisica f on c.id_compra=f.id_compra)
	-- recorre
	select @v_mes = dateadd(month, 1,@v_fechaMinima)

	declare @v_max int, @v_maxVentas int

	while(@v_mes <= @v_fechaMaxima)
	begin

		select @v_max=(select top(1) id_usuario from venta.Fisica f
		inner join venta.Compra c on f.id_compra=c.id_compra
		where fecha_compra >= @v_fechaMinima and fecha_compra <= @v_mes
		group by id_usuario order by count(f.id_compra) desc)

		select @v_maxVentas=(select top(1) count(id_usuario) from venta.Fisica f
		inner join venta.Compra c on f.id_compra=c.id_compra
		where fecha_compra >= @v_fechaMinima and fecha_compra <= @v_mes
		group by id_usuario order by count(f.id_compra) desc)

		select @v_maxVentas ventas,@v_fechaMinima inicio, @v_mes fin, v.id_usuario , ap_paterno+' '+isnull(ap_materno, '-')+' '+nombre vendedor
		from persona.Vendedor v
		inner join persona.Usuario u on v.id_usuario=u.id_usuario
		where v.id_usuario=@v_max

		set @v_fechaMinima = @v_mes
		set @v_mes = dateadd(month, 1,@v_fechaMinima)
	end
	if(@v_fechaMinima <= @v_fechaMaxima)
	begin
		select @v_max=(select top(1) id_usuario from venta.Fisica f
		inner join venta.Compra c on f.id_compra=c.id_compra
		where fecha_compra >= @v_fechaMinima and fecha_compra <= @v_fechaMaxima
		group by id_usuario order by count(f.id_compra) desc)

		select @v_maxVentas=(select top(1) count(id_usuario) from venta.Fisica f
		inner join venta.Compra c on f.id_compra=c.id_compra
		where fecha_compra >= @v_fechaMinima and fecha_compra <= @v_fechaMaxima
		group by id_usuario order by count(f.id_compra) desc)

		select @v_maxVentas ventas,@v_fechaMinima inicio, @v_fechaMaxima fin, v.id_usuario , ap_paterno+' '+isnull(ap_materno, '-')+' '+nombre vendedor
		from persona.Vendedor v
		inner join persona.Usuario u on v.id_usuario=u.id_usuario
		where v.id_usuario=@v_max
	end
	
end
go

execute persona.pusuMayorVendedor
go

-- 2. en qué épocas se realizan más ventas (por periodo de tiempo/mes)

create or alter procedure venta.pusuEpoca
	
as
begin
	declare @mes varchar(20)

	--select count(id_compra) compras,month(fecha_compra) mes from venta.Compra
	--group by month(fecha_compra)

	select count(id_compra) 'cantidad de compras',case month(fecha_compra) -- asigna diferentes valores a mes
				when 1	then 'ENERO'
				when 2	then 'FEBRERO'
				when 3	then 'MARZO'
				when 4	then 'ABRIL'
				when 5	then 'MAYO'
				when 6	then 'JUNIO'
				when 7	then 'JULIO'
				when 8	then 'AGOSTO'
				when 9	then 'SEPTIEMBRE'
				when 10	then 'OCTUBRE'
				when 11	then 'NOVIEMBRE'
				when 12	then 'DICIEMBRE'
				else 'No es un mes valido'
			end mes from venta.Compra
	group by month(fecha_compra)
	order by count(id_compra) desc
end
go

execute venta.pusuEpoca
go
-- 3. qué productos son los más comprados al día del reporte,

create or alter procedure venta.pusuMasComprado
as
begin
	
	select top(1) cp.clave 'clave producto',nombre,  count(cantidad) cantidad
		from venta.CestaProducto cp
		inner join catalogo.Producto p on p.clave=cp.clave
		inner join venta.Cesta c on cp.id_cesta=c.id_cesta
		inner join venta.Compra vc on c.id_cesta=vc.id_cesta
		where estado='C' and fecha_compra<=  getdate()
		group by cp.clave, nombre
		order by count(cantidad) desc

end

execute venta.pusuMasComprado
go


--  4. por qué medio se realizan más ventas (internet o físico) en un periodo de tiempo. 

create or alter procedure venta.pusuTipoVentas	
as
begin
	select  case month(fecha_compra)
		when 1	then 'ENERO'
		when 2	then 'FEBRERO'
		when 3	then 'MARZO'
		when 4	then 'ABRIL'
		when 5	then 'MAYO'
		when 6	then 'JUNIO'
		when 7	then 'JULIO'
		when 8	then 'AGOSTO'
		when 9	then 'SEPTIEMBRE'
		when 10	then 'OCTUBRE'
		when 11	then 'NOVIEMBRE'
		when 12	then 'DICIEMBRE'
		else 'No es un mes valido'
	end mes,tipo_compra 'tipo con mas ventas',
	count(id_compra) compras  from venta.Compra 
		group by tipo_compra, month(fecha_compra)
		order by month(fecha_compra) asc
end
go

execute venta.pusuTipoVentas	
