require "find"
require 'taglib'
require_relative "RolaConst.rb"
require_relative '../BaseDeDatos/ControlDeBase.rb'

class Minero

  def registraElementos()
    Find.find('../MusicaEjemplo/') do |f|
      if File.file?(f)
        rola=Minero.new.empaquetaEtiquetas(f)
        ControlDeBase.new.addBaseRola(rola)
      end
    end
  end

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
      r= RolaContr.new(interprete,titulo,album,año,genero,noAlbum)
      return r
    end
  end
  def cuentaElementos
    elementos=0
    Find.find('../MusicaEjemplo/') do |f|
      if File.file?(f)
        elementos=elementos+1
      end
    end
    return elementos
  end
end
end
s=ControlDeBase.new
s.creaBase()
#puts Minero.new.cuentaElementos
Minero.new.registraElementos
