-- Prueba de triggers | archivo: validatriggers.sql
-- Proyecto final BD
use PROYECTO_FINAL_EQUIPO4_2022_2
go
/*
TRIGGER: catalogo.tr_producNoti
Notifica a los clientes suscritos de un producto el cambio en el precio de este
*/
select id_usuario,p.clave,p.nombre from venta.Suscribe s
inner join catalogo.Producto p on s.clave=p.clave

update catalogo.Producto --cuando hacemos un update al precio del producto se notifica al usuario de dicho cambio
	set precio=65 --se indica el nuevo precio del producto
where clave=10

/*
TRIGGER: catalogo.tr_ofertaNoti
Notifica a los usuarios suscritos si hubo una oferta registrada para el producto
*/
select op.id_oferta, p.clave,p.nombre, o.descripcion from logistica.OfertaProducto op
inner join logistica.Oferta o on op.id_oferta=o.id_oferta
inner join catalogo.Producto p on op.clave=p.clave

select id_usuario,p.clave,p.nombre from venta.Suscribe s
inner join catalogo.Producto p on s.clave=p.clave
-- al insertar en ofertaProducto se detecta nueva oferta para el producto, y se notifica a todos los suscritos.
insert into logistica.OfertaProducto(id_oferta,clave)
values (2,1)

/*
TRIGGER: persona.tr_crearCesta
Crea una cesta para un nuevo comprador.
*/
exec persona.pa_registrarComprador 'NOMBRE PRUEBA', 'APATERNO','AMATERNO','USERPRUEBA',
    'PPPPPPPPPPPPPPPPPP','contrasena1234','H', '2001-04-15','prueba@gmail.com', 'Pedregal',
	'Coyoacan',null,'Gustavo A. Madero',7, 1234522112
select * from persona.Usuario
select * from venta.Cesta

/*
TRIGGER:venta.tr_verificaCestaActiva
Trigger para que cada que se intente crear una cesta para un usuario se verifique si no existe ya una cesta activa
*/
insert into venta.Cesta values (GETDATE(),'A',1)

/*
TRIGGER: persona.tr_validaVendedor
-- Trigger validar que el usuario ingresado a Vendedor si sea
*/
exec persona.pa_registrarVendedor 'NOMBRE Vendedor', 'APATERNO','AMATERNO','USERPSELL',
    'PPPPPPPPPPPPPPPAAA','contrasena1235','H', '2001-04-15','pruebavende@gmail.com', 6000,
	'Pedregal', 'Coyoacan',null,'Gustavo A. Madero',7, 1234522133
select v.id_usuario, nombre+' '+ap_paterno+' '+isnull(ap_materno,'-'), tipo_registrado from persona.Vendedor v
inner join persona.Usuario u on v.id_usuario=u.id_usuario

/*
TRIGGER: persona.tr_validaGestor
Trigger validar que el usuario ingresado a Gestor si sea Gestor
*/
exec persona.pa_registrarVendedor 'NOMBRE GESTOR', 'APATERNO','AMATERNO','USERGest',
    'PPPPPPPPPPPPPPPBBB','contrasena2222','H', '2001-04-15','pruebageste@gmail.com', null,
	'Pedregal', 'Coyoacan',null,'Gustavo A. Madero',7, 1234522144
select * from persona.Usuario

select g.id_usuario, nombre+' '+ap_paterno+' '+isnull(ap_materno,'-'), tipo_registrado from persona.Gestor g
inner join persona.Usuario u on g.id_usuario=u.id_usuario

/*
TRIGGER:persona.tr_validaComprador
-- Trigger validar que el usuario ingresado a Comprador si sea
*/

exec persona.pa_registrarComprador 'NOMBRE Comprador', 'APATERNO','AMATERNO','USER99',
    'PPPPPPPPPPPPPPPCCC','contrasena5555','H', '2001-04-15','gatito@gmail.com',
	'Pedregal', 'Coyoacan',null,'Gustavo A. Madero',7, 1234522177
select c.id_usuario, nombre+' '+ap_paterno+' '+isnull(ap_materno,'-'), tipo_registrado from persona.Comprador c
inner join persona.Usuario u on c.id_usuario=u.id_usuario
