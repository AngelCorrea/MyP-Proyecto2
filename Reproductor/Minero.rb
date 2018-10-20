require "find"
require 'taglib'
require_relative "RolaConst.rb"
require_relative '../BaseDeDatos/ControlDeBase.rb'
require 'etc'

#Clase para minar los archivos del directorio Music
class Minero
#Metodo que recorre un directorio y toma todos los archivos de musica,
#crea un objeto y los agrega a la base de datos
  def registraElementos()
    Find.find('/home/'+Etc.getlogin+'/Music') do |f|
      if File.file?(f)
        rola=Minero.new.empaquetaEtiquetas(f)
        ControlDeBase.new.addBaseRola(rola)
      end
    end
  end

#Metodo que cuenta los elementos de una un directorio
  def cuentaElementos()
    elementos=0
    Find.find('/home/'+Etc.getlogin+'/Music') do |f|
      if File.file?(f)
        elementos=elementos+1
      end
    end
    return elementos
  end

#Metodo para la extraccion de las etiquetas de lo archivos de musica
  def empaquetaEtiquetas(file)
    TagLib::FileRef.open(file)do |fileref|
    unless fileref.null?
      tag = fileref.tag
      interprete=tag.artist  #=> "Artista"
      titulo=(tag.title)   #=> "Titulo"
      album=tag.album   #=> "Nombre del album"
      año=tag.year    #=> Año
      genero=tag.genre   #=> Genero
      noAlbum=tag.track   #=> Numero de cancion en el album
      path=file
      r= RolaContr.new(interprete,titulo,album,año,genero,noAlbum,path)
      return r
    end
  end
end
end
