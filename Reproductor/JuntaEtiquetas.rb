require 'taglib'
class JuntaEtiquetas
  def etiquetas(file)
    TagLib::FileRef.open(file)do |fileref|
      unless fileref.null?
        tag = fileref.tag
        puts tag.title   #=> "Titulo"
        puts tag.artist  #=> "Artista"
        puts tag.album   #=> "Nombre del album"
        puts tag.year    #=> Año
        puts tag.track   #=> Numero de cancion en el album
        puts tag.genre   #=> Genero
        puts "-------------------------------------------"
      end
    end
  end
end
