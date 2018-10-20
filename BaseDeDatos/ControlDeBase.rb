require 'sqlite3'

class ControlDeBase
#Metodo para la creacion de la base de datos.
  def creaBase
    if(File.exists?('../BaseDeDatos/base.db'))
    else
      File.open('../BaseDeDatos/base.db','w') do |base|
        @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
        rows = @@db.execute <<-SQL
        CREATE TABLE types (
          id_type INTEGER PRIMARY KEY ,
          description TEXT
        );
        SQL
        @@db.execute <<-SQL
        CREATE TABLE performers (
          id_performer INTEGER PRIMARY KEY ,
          id_type INTEGER ,
          name TEXT ,
          FOREIGN KEY ( id_type ) REFERENCES types ( id_type )
        );)
        SQL
        @@db.execute <<-SQL
        CREATE TABLE persons (
          id_person INTEGER PRIMARY KEY ,
          stage_name TEXT ,
          real_name TEXT ,
          birth_date TEXT ,
          death_date TEXT
        );
        SQL
        @@db.execute <<-SQL
        CREATE TABLE groups (
          id_group INTEGER PRIMARY KEY ,
          name TEXT ,
          start_date TEXT ,
          end_date TEXT
        );
        SQL
        @@db.execute <<-SQL
        CREATE TABLE albums (
          id_album INTEGER PRIMARY KEY ,
          path TEXT ,
          name TEXT ,
          year INTEGER
        );
        SQL
        @@db.execute <<-SQL
        CREATE TABLE rolas (
          id_rola INTEGER PRIMARY KEY ,
          id_performer INTEGER ,
          id_album INTEGER ,
          path TEXT ,
          title TEXT ,
          track INTEGER ,
          year INTEGER ,
          genre TEXT ,
          FOREIGN KEY ( id_performer )
          REFERENCES performers ( id_performer ) ,
          FOREIGN KEY ( id_album )
          REFERENCES albums ( id_album )
        );
        SQL
        @@db.execute <<-SQL
        CREATE TABLE in_group (
          id_person INTEGER ,
          id_group INTEGER ,
          PRIMARY KEY ( id_person , id_group ) ,
          FOREIGN KEY ( id_person ) REFERENCES persons ( id_person ) ,
          FOREIGN KEY ( id_group ) REFERENCES groups ( id_group )
        );
        SQL
        @@db.execute("INSERT INTO types VALUES (? , ?);",[0,'Person '])
        @@db.execute("INSERT INTO types VALUES (? , ?);",[1 ,'Group '])
        @@db.execute("INSERT INTO types VALUES (? , ?);",[2 , 'Unknown '])

      end
    end

  end

#Metodo para poblar la base de datos con los archivos de musica
  def addBaseRola (objetoRola)
    album=objetoRola.nombreAlbum
    noAlbum=objetoRola.noAlbum
    año=objetoRola.año
    nombreInterprete=objetoRola.inter
    path=objetoRola.path
    genre=objetoRola.genero
    title=objetoRola.titulo
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    pathExistente = @@db.execute("SELECT path FROM rolas WHERE path=? ",[path])
    if(pathExistente[0]=="" or pathExistente[0]==nil)
      @@db.execute("INSERT INTO performers (id_type,name) VALUES(?,?);",[2,nombreInterprete])
      @@db.execute("INSERT INTO albums (path,name,year) VALUES (?,?,?);",[path,album,año])

      idPerformer=@@db.execute("SELECT id_performer FROM performers WHERE name = ?",[nombreInterprete])
      idPerformer=idPerformer[0]
      idAlbum=@@db.execute("SELECT id_album FROM albums WHERE name=?",[album])
      idAlbum=idAlbum[0]
      @@db.execute("INSERT INTO rolas (id_performer,id_album,path,title,track,year,genre) VALUES(?,?,?,?,?,?,?)",[idPerformer,idAlbum,path,title,noAlbum,año,genre])
    end
  end

  def actualizarDatoIdType(nuevaIdType,interprete)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    @@db.execute("UPDATE performers SET id_type=? WHERE name= ? ",[nuevaIdType,interprete])
  end

  def actualizaBanda(nombre,fechaInicio,fechaFinal)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    if(fechaInicio!=nil)
      @@db.execute("UPDATE groups SET start_date=? WHERE name = ?",[fechaInicio,nombre])
    end
    if (fechaFinal!= nil)
      @@db.execute("UPDATE groups SET end_date=? WHERE name = ?",[fechaFinal,nombre])
    end
  end

  def actualizaArtista(stage_name,real_name,birth_date,death_date)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    if(real_name!=nil)
      @@db.execute("UPDATE persons SET real_name=? WHERE stage_name = ?",[real_name,stage_name])
    end
    if (birth_date!= nil)
      @@db.execute("UPDATE persons SET birth_date=? WHERE stage_name = ?",[birth_date,stage_name])
    end
    if(death_date!=nil)
      @@db.execute("UPDATE persons SET death_date=? WHERE stage_name = ?",[death_date,stage_name])
    end
  end

  def registrarPersona(stage_name,real_name,birth_date,death_date)
    if(real_name== nil or real_name=="")
      real_name="Unknown"
    end
    if (birth_date==nil or birth_date=="")
      birth_date="Unknown"
    end
    if (death_date == nil or death_date=="")
      death_date="Unknown"
    end
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    @@db.execute("INSERT INTO persons (stage_name,real_name,birth_date,death_date) VALUES (?,?,?,?)",[stage_name,real_name,birth_date,death_date])
  end

  def registrarGrupo(name,start_date,end_date)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    if(start_date==nil or start_date=="")
      start_date="Unknown"
    end
    if(end_date==nil or end_date=="")
      end_date="Unknown"
    end
    @@db.execute("INSERT INTO groups (name,start_date,end_date) VALUES (?,?,?)",[name,start_date,end_date])
  end

  def personaEnGrupo (personaName,grupoName)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    idPersona=@@db.execute("SELECT id_person FROM persons WHERE stage_name = ? ",[personaName])
    idGrupo=@@db.execute("SELECT id_group FROM groups WHERE name=?",[grupoName])
    @@db.execute("INSERT INTO in_group (id_person,id_group) VALUES (?,?)",[idPersona,idGrupo])
  end

  def tablaGeneralTitulos
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    titulos=@@db.execute("SELECT title FROM rolas ")
    return titulos
  end
  def tablaGeneralArtistas
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    artistas=@@db.execute("SELECT name FROM performers ")
    return artistas
  end
  def tablaGeneralAlbum
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    albums=@@db.execute("SELECT name FROM albums ")
    return albums
  end
  def tablaGeneralGenero
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    genero=@@db.execute("SELECT genre FROM rolas ")
    return genero
  end
  def tablaGeneralPath
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    path=@@db.execute("SELECT path FROM rolas ")
    return path
  end
  def busquedaPorTitulo(titulo)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT path FROM rolas WHERE title LIKE '%#{titulo.to_s}%' ")
    return resultados
  end
  def busquedaPorAlbum(name)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT path FROM albums WHERE name LIKE '%#{name.to_s}%' ")
    return resultados
  end
  def busquedaPorAutor(interprete)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    id=@@db.execute("SELECT id_performer FROM performers WHERE name LIKE '%#{interprete.to_s}%' ")
    i=0
    resultados=[]
    envoltura=[]
    while i<id.length
     envoltura=@@db.execute("SELECT path FROM rolas WHERE id_performer=?",[id[i]])
     resultados=envoltura | resultados
      i=i+1
    end
    return resultados
  end

  def buscaPorPath(path)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT id_performer FROM rolas WHERE path=?",[path])
    return resultados
  end

  def buscaPorId_Performer(id_performer)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT name FROM performers WHERE id_performer=?",[id_performer])
    return resultados
  end

  def buscarIdentificados(tipoTabla,name)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    if(tipoTabla=="persons")
      resultados=@@db.execute("SELECT * FROM #{tipoTabla} WHERE stage_name=? ",[name])
    else
      resultados=@@db.execute("SELECT * FROM #{tipoTabla} WHERE name=? ",[name])
    end
    return resultados
  end
  def buscarIdentificadosCompleto(tipoTabla)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT * FROM #{tipoTabla} ")
    return resultados
  end
  def busquedaInGrup(id)
    @@db = SQLite3::Database.new("../BaseDeDatos/base.db")
    resultados=@@db.execute("SELECT id_person FROM in_group WHERE id_group = #{id} ")
    return resultados
  end

end
