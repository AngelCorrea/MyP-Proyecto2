# MyP-Proyecto2
Base de datos para un reproductor mp3  
Autor: Correa Garcia Jose Angel  

Dependencias  
	-"ruby 2.5.1p57" (Estructura general)  
	- RUBYGEMS VERSION: 2.7.7  
  	- Gems sqlite3 (1.3.13)(Control con la base de datos)  
  	- Gems taglib-ruby (0.7.1)(Extraccion de Tag's de archivos de musica)  
  	- Gems fxruby (1.6.39) (Interfaz Grafica)  
  	- SQL3 (Base de datos)  
	
Como ejecutar el reproductor:  
    -Llame al clase "ReproductorMp3.rb" desde el directorio donde se encuentra (/MyP-Proyecto2/Reproductor/ReproductorMp3.rb)  
	"ruby ReproductorMp3.rb"  
  -Uso:
    -Para iniciar el programa despues de ejecutar el comando aparecera una ventana, por omision la mineria de archivos de musica se realizara en el directorio "~/home/(userName)/Music, para iniciar el proceso de extraccion de datos se debe apretar el boton de "Minar".
    -EL proceso de mineria es lento, debera esperar a que la ventana por si sola se actualice con todos los archivos registrados.  
    -El metodo de busqueda se puede realizar con 3 parametros distintos: Interprete(I:), Album(A:) y por Titulo(T:) separados por comas si se quieren realizar busquedas simultaneas.  
    -Un ejempo de busqueda es el siguiente: I:lu,A:ga,T:lov (El resultado de la busqueda seran todas las canciones cuyo interprete tenga "lu",con album con "ga" y con titulo "lov", todo en la palabra que la contenga)  
    -Para modificar o registrar una cancion, se debe hacer doble click en el renglon de la cancion que deseas modificar, a esto saldra una ventana emergente en en el que podras modificar o registrar el interprete como persona o como un grupo.  
    -Si se vuelve a hacer doble click en un interprete registrado, se abrira la pesaña correspondiente a donde se registro, y solo se permitira modificar los parametros sobre los que se ha registrado.  
    -Si se quiere registrar una persona en un grupo, desde un grupo registrado, deben apretar en el boton "Añadir persona" y se mostrara una lista de artistas registrados, de no haber, se pueden registrar y agregar directamente con el boton "Registrar persona" en la misma ventana.  
    
    
Advertencias:  
  -No se deben ingresar comandos SQL de ningun tipo, solo las entradas como se especifican.  
  -Todo archivo en el directorio "/Music" debe se exclusivamente musicales (mp3,m4a,...).  
  -No deben ingresarte comillas o apostrofes en la barra de busqueda.  
  
  
