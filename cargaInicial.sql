
-- DESCRIPCIÓN: Proyecto FINAL Equipo 4
-- Script 'creaBase.sql' (DDL)
-- Semestre 2022-2

-- USE  PRUEBAS_PROYECTO_FINAL;
use PROYECTO_FINAL_EQUIPO4_2022_2;
go

--Inserción de todos los usuarios
DBCC CHECKIDENT ('persona.usuario', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('persona.usuario', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('KATHARINA','GREY',NULL,'KATHAGREY','KATHARINA_GREY@GMAIL.COM','FABM770222MMSJNR00','Ov2LTQWiBFpl7Ah','1975-01-01','M','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('MITSUKO', 'WELLS', 'DIXON','WELUKO','MITSUKO_WELLS@GMAIL.COM','CACM980221HQRSHR01','t7VDCEbLt7BbG3B','1999-12-10','H','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('MARCY','HAWES','JENKINS', 'MARHAW','MARCY_HAWES@GMAIL.COM','JIMD000120MQRMNNA0','oP7w1fG3NUbFzRD','1994-11-04','H','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('KATHYRN', 'BARTLETT',NULL,'LETTKATHYRN','KATHYRN_BARTLETT@GMAIL.COM','ROOI011220MQRSSNA1','QhvqbX63uNPfjJb','1992-05-09','M','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('EARNEST', 'BARNES', 'HAMER','BAREST', 'EARNEST_BARNES@GMAIL.COM','CODK000707MQRRRRA2','L4Fq6HcKHTDKc4K','1963-11-17','H','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('DESPINA', 'DOLAN', 'SIMONS', 'DESPINADOL', 'DESPINA_DOLAN@GMAIL.COM','GICM020610HQRLRRA8','Wif8x_NXypLFSji','1994-11-12','M','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('REESE', 'WITHERSPOON', 'RAVER','REEWITHER','REESE_WITHERSPOON@GMAIL.COM','MANG010807HQRRXRA9','gaOaqp3WHGdm1Uo','1985-11-08','H','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('TREVOR', 'LINDEN', 'JOHN', 'LINDENTRE', 'TREVOR_LINDEN@GMAIL.COM','PACL010125HQRDNSA9','nL0NuxR1G2pOmOO','1980-02-28','H','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ISABELLE', 'REDMOND', 'EASTWOOD', 'REDMELLE', 'ISABELLE_REDMOND@GMAIL.COM','VAGD020208MQRLRNA4','C4fa2pIjHdQzgxq','1999-12-12','M','C')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('KENETH','LARKIN', 'NAVRATILOVA', 'LARKEN', 'KENETH_LARKIN@GMAIL.COM','CAMA010121HQRNCNA4','CST7xk6WoVNlUws','1990-04-10','H','C')

	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('CARLA', 'CHIMAS', 'KEME','LACHIMAS','CARLA_CHIMAS@GMAIL.COM','HOFA020220HQRNLDA0','4Gj1LjkZQCO26_I','1975-04-16','M','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ALAN', 'HUERTA', 'RUIZ','ALHUERTA','ALAN_HUERTA@GMAIL.COM','GXEI020906HQRTSRA8','R0IOGQHsAYINUau','1994-11-04','H','G' )
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('JONATHAN', 'MATUS', 'JOHANN', 'JONAMATUS','JONATHAN_MATUS@GMAIL.COM','OOCL010320HQRRRSA0','2$a$fXtF9Cz$ZPCV','1991-10-24','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('JESUS', 'PINTO', 'CORDOVA', 'JESUSTO','JESUS_PINTO@GMAIL.COM','AESE020409HVZLNLA1','w65H2ev%&FztU@QT','1979-01-11','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('JUNIOR', 'RAMIREZ', 'TAPIA','JUNREZ','JUNIOR_RAMIREZ@GMAIL.COM','CAMA021115MVZSYLA4','NApUvhnq^8C$P&k9','1971-06-15','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('JOSE', 'PACHECO', 'ZAPATA', 'SEPACH', 'JOSE_PACHECO@GMAIL.COM','FEDE020723MQRRZSA0','C5&BVs5c%sTXPC4u','1993-10-08','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('MICHEL', 'DOMINGUEZ', 'DIAZ', 'DOMINMICHEL', 'MICHEL_DOMINGUEZ@GMAIL.COM','BELD010227MQRRRNA1', 'NAU7DEn^4AEbQDb#','1987-12-10','M','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ERICK', 'VERDE', 'MATOS', 'ERICKVERDE', 'ERICK_VERDE@GMAIL.COM','LAAY010604HQRZNDA8','FCMnT%BUvYEc4Q9h','1978-09-18','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('KARIN', 'OLIVEROS', 'KAREROS', 'COLLI', 'KARIN_OLIVEROS@GMAIL.COM','CATP010830MQRMRRA4','zhEnM$%foJizY6r6','1963-08-22','H','G')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ANGEL', 'CANUL', 'MAC', 'ELCAN', 'ANGEL_CANUL@GMAIL.COM','CAJH000506HTCHVGA7','d!RSrs5GyC5&GzHR','1957-09-04','H','G')

	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('FRANCISCA', 'REYES', 'ACOPA', 'ISCAREYES', 'REYES_ACOPA@GMAIL.COM','MEZE000614HQRDXDB3','M&#fX83T9a4Qrtu#','1999-07-17','M','V')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ESTEFANI', 'ACOSTA', 'CHAN', 'FANIACOSTA', 'ESTEFANI_ACOSTA@GMAIL.COM','AAOE011207MQRRRLA2','xJG^w!8irjDKZUt5','1984-12-20','M','V')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ILSE', 'ARGUELLO', 'MAY', 'ARGUIL', 'ILSE_ARGUELLO@GMAIL.COM','GABI010427HTSRTRA2','Syuf6!Qkha9LWq#V', '1996-10-28','M','V')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('ERNESTO', 'ASENCIO', 'RUIZ', 'ERNECIO', 'ERNESTO_ASENCIO@GMAIL.COM', 'BALR971019MQRLNS09','6PwN&TcfUq6MauK6','1998-01-07','H','V')
	INSERT INTO persona.Usuario(nombre,ap_paterno,ap_materno,username,email,curp,contrasena,fecha_nacimiento,genero,tipo_registrado)
	VALUES('JOSE', 'CORTES', 'GONZALEZ', 'CORSE', 'JOSE_CORTES@GMAIL.COM', 'JIPG930204HQRMRL05','5Lq$CyDhhCte3XrG','1987-02-09','H','V')
	
	SELECT * FROM persona.usuario ORDER by tipo_registrado
COMMIT TRAN

--Inserción de domicilio y telefono
DBCC CHECKIDENT ('persona.domicilio', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('persona.domicilio', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO persona.domicilio(calle,num_interior,colonia,alcaldia,num_exterior,id_usuario)
	VALUES('MONTE ALBAN',1,'LA MARTINICA','TLALPAN',10,1),
	('HIDALGO',2,'SANTA CECILIA','TLALPAN',23,2),
	('20 DE NOVIEMBRE',3,'POLVORA','MIGUEL HIDALGO',230,3),
	('BATALLA DE NACO',4,'LA RAZA','AZCAPOTZALCO',54,4),
	('MATAPULGAS',5,'BARRIO NORTE','IZTAPALAPA',120,5),
	('GOMA',6,'LA COLMENA','AZCAPOTZALCO',65,6),
	('BARRANCA DEL MUERTO',7,'EL TRIANGULO','TLALPAN',68,7),
	('RAYANDO EL SOL',8,'BARRIO NORTE','XOCHIMILCO',87,8),
	('CALLE DE LA AMARGURA',9,'TLAXOPAN','MIGUEL HIDALGO',84,9),
	('MAREMOTO',10,'ARTURO GAMIZ','XOCHIMILCO',78,10),
	('PLATEROS',11,'SAN ANTONIO','IZTACALCO',89,11),
	('CALZADA DEL TEPEYAC',12,'LIBERTAD','AZCAPOTZALCO',129,12),
	('EJE CENTRAL',13,'SEVILLA','VENUSTIANO CARRANZA',91,13),
	('DEMACU',14,'PALMAS','IZTACALCO',21,14),
	('FRANCISCO VILLA',15,'TLAZINTLA','IZTACALCO',67,15),
	('TEOFANI',16,'ISIDRO FABELA','IZTAPALAPA',18,16),
	('LAGUNILLA',17,'AGRICULTURA','MIGUEL HIDALGO',216,17),
	('FRESNO',18,'TETLALPAN','IZTACALCO',35,18),
	('OLVERA',19,'SANTA ROSA','XOCHIMILCO',42,19),
	('TOTHIE',20,'MINERVA','IZTAPALAPA',76,20),
	('COLORADO',21,'LA JOYA','IZTACALCO',43,21),
	('MEZQUITAL',22,'LA CONCHA','XOCHIMILCO',42,22),
	('CHICHIMECAS',23,'LOS CEDROS','TLALPAN',26,23),
	('CASA BLANCA',24,'FUEGO NUEVO','IZTAPALAPA',24,24),
	('XUCHITLAN',25,'ARENAL','AZCAPOTZALCO',64,25)
	SELECT * FROM persona.domicilio
COMMIT TRAN


DBCC CHECKIDENT ('persona.Telefono', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('persona.Telefono', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO persona.Telefono(telefono,id_usuario)
	VALUES('3334326500',1),
	('1857624750',2),
	('7102161854',3),
	('8850501583',4),
	('4016582659',5),
	('6282377785',6),
	('4524783027',7),
	('4463629605',8),
	('8725404978',9),
	('9337630454',10),
	('8704798629',11),
	('8473593071',12),
	('8731639527',13),
	('2101074993',14),
	('6605903181',15),
	('1254207930',16),
	('4211710056',17),
	('5265584666',18),
	('1012816830',19),
	('4186282847',20),
	('4681815489',21),
	('2140303485',22),
	('5159324058',23),
	('3054503436',24),
	('8698047502',25)
	SELECT * FROM persona.Telefono
COMMIT TRAN

--Inserción de los gestores.
BEGIN TRAN
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(11,null)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(12,11)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(13,null)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(14,null)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(15,12)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(16,null)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(17,14)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(18,null)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(19,18)
	INSERT INTO persona.Gestor(id_usuario,supervisor_gestor)
	VALUES(20,11)
	SELECT * FROM persona.Gestor
COMMIT TRAN

--Inserción de los compradores
BEGIN TRAN
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(1)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(2)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(3)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(4)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(5)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(6)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(7)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(8)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(9)
	INSERT INTO persona.Comprador(id_usuario)
	VALUES(10)
	SELECT * FROM persona.Comprador
COMMIT TRAN

--Inserción de los vendedores
BEGIN TRAN
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES
	(20,10000)
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES(21,7000)
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES(22,6000)
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES(23,8000)
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES(24,6500)
	INSERT INTO persona.Vendedor(id_usuario,sueldo)
	VALUES(25,7500)
	SELECT * FROM persona.vendedor
COMMIT TRAN

--Inserción categorías
DBCC CHECKIDENT ('catalogo.Categoria', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('catalogo.Categoria', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO catalogo.Categoria(categoria_padre,nombre,id_gestor)
	VALUES
	(NULL,'ELECTRONICOS',11),
	(NULL,'LIBROS',13),
	(NULL,'SOFTWARE',15),
	(NULL,'MODA',17)
	SELECT * FROM catalogo.Categoria
COMMIT TRAN


--Inserción de productos
DBCC CHECKIDENT ('catalogo.Producto', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('catalogo.Producto', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO catalogo.Producto(nombre,cantidad_re_orden,descripcion,descripcion_detallada,precio,stock,id_gestor,id_categoria)
	VALUES('Pantalla Hisense',0,'HD VIDAA 32H5G (2021)','Abre un mundo de contenido a través del sistema operativo inteligente VIDAA OS de Hisense',3500,100,11,1),
	('Corsair Elgato Stream Deck',0,'Controlador para contenido en directo','15 teclas LCD personalizables soporte ajustable Windows 10 y macOS 1011 o posterior',2959,50,11,1),
	('NIERBO',0,'Proyector Universal Soporte','Giratorio de 360 con Longitud Extensible 118 Pulgadas a 197 Pulgadas / 11 lb Soporte de Montaje de Carga para Mini Proyector Cámara CCTV DVR',550,20,11,1),
	('Reproductor de Blu-ray Disc',0,'Sony con super Wi-Fi BDP-S3500 Full HD 1080p','Disfruta de una Red Wi-Fi rápida y estable incluso cuando transmites en HDArranca en menos de un segundo..',2360,10,11,1),
	('Onkyo HT-S9800',0,'Sistema de Cine en Casa Color Negro',' entradas HDMI y 2 salidas con soporte 3D y canal de regreso de audio',42911,70,11,1)

	INSERT INTO catalogo.Producto(nombre,cantidad_re_orden,descripcion,descripcion_detallada,precio,stock,id_gestor,id_categoria)
	VALUES('Gato Tiene Sueño',0,'Esta es una simpática y familiar historia','Esta es una simpática y familiar historia donde el protagonista, un gato, lo único que quiere hacer es dormir.',60,100,13,2),
	('Perro Tiene Sed',0,'Un perro que tenía sed','Un perro que tenía sed, y cada vez tenía más, empezó a ver con verdadero pesimismo el poder tomar un poco de agua. ',64,50,13,2),
	('Pato Esta Sucio',0,'Cierto día un pato limpio y arreglado...','Cierto día, un pato limpio y arreglado salió a pasear, pero no era día para ello, pues empezaron las desgracias como se podrán imaginar',80,20,13,2),
	('Colores De Elmer',0,'Élmer le encantan los colores','e gusta el blanco de la nieve y el verde del pasto el rojo del atardecer y el delicioso rosa de una paleta de fresa el azul del cielo y el negro de la noche',40,10,13,2),
	('Lobo',0,'¿Qué hace Lobo mientras los niños...','Lobo se pone sus ojos, su nariz, su boca y sus dientes. GRRRRRRRR y su servilleta para comer su zanahoria.',64,70,11,2)

	INSERT INTO catalogo.Producto(nombre,cantidad_re_orden,descripcion,descripcion_detallada,precio,stock,id_gestor,id_categoria)
	VALUES('Norton 360 Premium',0,'Software Antivirus','Copia de Seguridad de 75GB para PC, Control Parental [Windows, MacOS, Android, iOS]',680,100,15,3),
	('Microsoft 365 Personal',0,'Suscripción anual','Para 1 PC o Mac, 1 tableta incluyendo iPad, Android, o Windows, además de 1 teléfono',1000,50,15,3),
	('Microsoft 365 Familia 2021',0,'Suscripción anual','Para 6 personas | Para PCs o Macs, tabletas incluyendo iPad, Android, o Windows, además de teléfonos',1339,20,15,3),
	('CorelDRAW Graphics Suite 2021',0,'Graphic Design Software for Professionals','Vector Illustration, Layout, and Image Editing | Amazon Exclusive ParticleShop Brush Pack [PC Disc]',13242,10,15,3),
	('Adobe Photoshop Elements',0,'ADOBE SENSEI AI TECHNOLOGY','Automated options do the heavy lifting so you can instantly turn photos into art',2917,70,15,3)

	INSERT INTO catalogo.Producto(nombre,cantidad_re_orden,descripcion,descripcion_detallada,precio,stock,id_gestor,id_categoria)
	VALUES('Smartwatch Pulsera Inteligente',0,'Salandens Reloj Deportivo Pantalla Táctil Completa','Pulsera Actividad Impermeable IPX7 monitores de actividad con Pulsómetro y Presión Arterial',600,100,17,4),
	('Stargoods',0,'Camiseta Interior Deportiva','Faja Moldeadora y Compresión de Abdomen para Hombre',350,50,17,4),
	('Amazon Essentials',0,'chamarra de forro polar','chamarra de forro polar con cierre en los cuartos Chamarra de lana para Hombre',500,20,17,4),
	('HaoMay',0,'Chaquetas casuales','con cremallera completa para hombre',2360,10,17,4),
	('PIXNET',0,'Chaqueta bomber para hombre','MA-1 militar Flight Jacket multibolsillo bordado con cremallera completa cortavientos abrigo ligero para exteriores',1500,70,17,4)
	SELECT * FROM catalogo.Producto
COMMIT TRAN

--Insertar Ofertas
DBCC CHECKIDENT ('logistica.Oferta', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('logistica.Oferta', RESEED,0); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT INTO logistica.Oferta(tipo,descripcion,fecha_inicio,fecha_fin,id_usuario)
	VALUES('Envíos gratis','Al comprar cierta cantidad no pagas envio','2022-05-01','2022-05-29',12),
	('Porcentaje de descuento','Descuento por comprar','2022-04-01','2022-04-29',14),
	('2X1','Al comprar una cantidad recibes producto extra','2022-03-01','2022-03-29',16),
	('Regalo por compra','Al comprar un producto te llevas algo','2022-01-01','2022-01-29',18),
	('Oferta del mes','Oferta unica del mes','2022-06-01','2022-06-29',20)
	SELECT * FROM logistica.Oferta
COMMIT TRAN


BEGIN TRAN
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(1,1)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(1,2)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(1,3)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(1,4)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(2,5)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(2,6)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(2,7)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(2,8)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(3,9)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(3,10)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(3,11)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(3,12)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(4,13)
	INSERT into logistica.OfertaProducto(id_oferta,clave)
	VALUES(4,16)
	SELECT * from logistica.OfertaProducto
	-- SELECT * FROM catalogo.Producto
COMMIT TRAN

--Insertar Cestas
-- DBCC CHECKIDENT ('venta.Cesta', NORESEED); --Verificar numero del identificador ultimo
-- GO 
-- DBCC CHECKIDENT ('venta.Cesta', RESEED,1); --Reiniciar en cero el identificador
-- go

BEGIN TRAN
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-01-29','C',1)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-01-28','C',1)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-02-27','C',2)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-02-26','C',2)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-03-25','C',3)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-03-24','C',3)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-04-23','C',4)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-04-22','C',4)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-05-21','C',5)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-05-19','C',5)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-04-18','C',6)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-04-29','C',6)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-03-23','C',7)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-03-29','C',7)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-02-02','C',8)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-02-21','C',8)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-01-11','C',9)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2022-01-05','C',9)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2021-10-05','C',10)
	INSERT into venta.Cesta(fecha_registro,estado,id_usuario)
	VALUES('2021-10-06','C',10)
	SELECT * FROM venta.Cesta
	-- select * from persona.Comprador
COMMIT TRAN

insert into venta.Cesta(fecha_registro,estado,id_usuario) VALUES('2022-02-27','C',2)

SELECT * from venta.Cesta
--Insertar VentaProducto
BEGIN TRAN
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(1,1,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(2,2,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(3,2,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(4,4,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(5,5,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(6,6,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(7,7,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(8,8,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(9,9,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(10,10,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(11,11,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(12,12,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(13,13,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(14,14,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(15,15,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(16,16,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(17,17,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(18,18,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(19,19,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(20,20,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(21,1,1)--Cesta que estan activas de compra
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(22,2,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(23,3,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(24,4,1)
	INSERT into venta.CestaProducto(id_cesta,clave,cantidad)
	VALUES(25,5,1)
	SELECT * FROM venta.CestaProducto
COMMIT TRAN

--Insertar suscribe
BEGIN TRAN
	INSERT into venta.Suscribe(id_usuario,clave)
	VALUES(1,1),
	(2,2),
	(3,3),
	(4,4),
	(5,5),
	(6,6),
	(7,7),
	(8,8),
	(9,9),
	(10,10)
	SELECT * FROM venta.Suscribe
COMMIT TRAN

--Insertar suscribe
DBCC CHECKIDENT ('logistica.MedioEnvio', NORESEED); --Verificar numero del identificador ultimo
GO 
DBCC CHECKIDENT ('logistica.MedioEnvio', RESEED,1); --Reiniciar en cero el identificador
go

BEGIN TRAN
	INSERT into logistica.MedioEnvio(medio)
	VALUES('Terrestre'),
	('Aereo'),
	('Maritimo')
	SELECT * FROM logistica.MedioEnvio
COMMIT TRAN


-- Se insertan algunas compras mediante el procedimiento venta.pa_comprarCestaOnline

EXECUTE venta.pa_comprarCestaOnline 1,1;
EXECUTE venta.pa_comprarCestaOnline 2,2;
EXECUTE venta.pa_comprarCestaOnline 3,3;

-- Se insertan algunas compras mediante el procedimiento venta.pa_comprarCestaFisica

EXECUTE venta.pa_comprarCestaFisica 4,1;
EXECUTE venta.pa_comprarCestaFisica 5,2;

