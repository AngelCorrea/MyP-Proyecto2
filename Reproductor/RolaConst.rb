class RolaContr
#Clase Contructora del objeto rola
#Si alguno de los parametros no se encuentra en el archivo (ser nil o una cadena
#vacia) se el asignara Unknown por omision

  def initialize(interprete,titulo,nombreAlbum,año,genero,noAlbum,path)
    @path=path
    if (interprete==nil or interprete== "")
      @interprete="Unknown"
    else
      @interprete=interprete
    end

    if (titulo==nil or titulo== "")
      @titulo= "Unknown"
    else
      @titulo=titulo
    end

    if (nombreAlbum==nil or nombreAlbum=="")
      @nombreAlbum= "Unknown"
    else
      @nombreAlbum=nombreAlbum
    end

    if (año==nil or año=="")
      @año=0
    else
      @año=año
    end

    if (genero==nil or genero=="")
      @genero="Unknown"
    else
      @genero=genero
    end

    if (noAlbum==nil or noAlbum=="")
      @noAlbum=0
    else
      @noAlbum = noAlbum
    end
  end

  def inter
    return @interprete
  end
  def titulo
    return @titulo
  end

  def nombreAlbum
    return @nombreAlbum
  end

  def año
    return @año
  end
  def genero
    return @genero
  end
  def noAlbum
    return @noAlbum
  end
  def path
    return @path
  end
end
