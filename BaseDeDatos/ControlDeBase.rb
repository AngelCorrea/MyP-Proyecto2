require 'sqlite3'

class ControlDeBase
  def creaBase
    if(File.exists?('base.db'))
      puts " hay archivo"
    else
      puts "no hay arvhivo"
      File.open('base.db','w') do |base|
        @@db = SQLite3::Database.new("base.db")
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
  def addBaseRola (objetoRola)
    album=objetoRola.nombreAlbum
    noAlbum=objetoRola.noAlbum
    año=objetoRola.año
    nombreInterprete=objetoRola.inter
    path=objetoRola.path
    genre=objetoRola.genero
    title=objetoRola.titulo
    @@db = SQLite3::Database.new("base.db")
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
    @@db = SQLite3::Database.new("base.db")
    @@db.execute("UPDATE performers SET id_type=? WHERE name= ? ",[nuevaIdType,interprete])
  end

  def actualizaBanda(fechaInicio,fechaFinal,nombre)
    @@db = SQLite3::Database.new("base.db")
    if(fechaInicio!=nil)
      @@db.execute("UPDATE groups SET start_date=? WHERE name = ?",[fechaInicio,name])
    end
    if (fechaFinal!= nil)
      @@db.execute("UPDATE groups SET end_date=? WHERE name = ?",[fechaFinal,name])
    end
  end

  def actualizaArtista(stage_name,real_name,birth_date,death_date)
    @@db = SQLite3::Database.new("base.db")
    if(real_name!=nil)
      @@db.execute("UPDATE person SET real_name=? WHERE stage_name = ?",[real_name,stage_name])
    end
    if (birth_date!= nil)
      @@db.execute("UPDATE person SET birth_date=? WHERE name = ?",[birth_date,stage_name])
    end
    if(death_date!=nil)
      @@db.execute("UPDATE person SET death_date=? WHERE name = ?",[death_date,stage_name])
    end
  end

  def registrarPersona(stage_name,real_name,birth_date,death_date)
    if(real_name== nil)
      real_name="Unknown"
    end
    if (birth_date==nil)
      birth_date="Unknown"
    end
    if (birth_date==nil)
      birth_date="Unknown"
    end
    if (death_date == nil)
      death_date="Unknown"
    end
    @@db = SQLite3::Database.new("base.db")
    @@db.execute("INSERT persons (stage_name,real_name,birth_date,death_date) VALUES(?,?,?,?)"[stage_name,real_name,birth_date,death_date])
  end

  def registrarGrupo(name,start_date,end_date)
    @@db = SQLite3::Database.new("base.db")
    if(start_date==nil)
      start_date="Unknown"
    end
    if(end_date==nil)
      end_date="Unknown"
    end
    @@db.execute("INSERT groups (name,start_date,end_date) VALUES (?,?,?)",[name,stage_name,end_date])
  end

  def personaEnGrupo (personaName,grupoName)
    @@db = SQLite3::Database.new("base.db")
    idPersona=@@db.execute("SELECT id_person FROM person WHERE stage_name = ? ",[personaName])
    idGrupo=@@db.execute("SELECT id_group FROM groups WHERE name=?",[grupoName])
    @@db.execute("INSERT INTO in_group (id_person,id_group) VALUES (?,?)",[idPersona,idGrupo])
  end

  def tablaGeneralTitulos
    @@db = SQLite3::Database.new("base.db")
    titulos=@@db.execute("SELECT title FROM rolas ")
    return titulos
  end
  def tablaGeneralArtistas
    @@db = SQLite3::Database.new("base.db")
    artistas=@@db.execute("SELECT name FROM performers ")
    return artistas
  end
  def tablaGeneralAlbum
    @@db = SQLite3::Database.new("base.db")
    albums=@@db.execute("SELECT name FROM albums ")
    return albums
  end
  def tablaGeneralGenero
    @@db = SQLite3::Database.new("base.db")
    genero=@@db.execute("SELECT genre FROM rolas ")
    return genero
  end
  def tablaGeneralPath
    @@db = SQLite3::Database.new("base.db")
    path=@@db.execute("SELECT path FROM rolas ")
    return path
  end
  def busquedaPorTitulo(titulo)
    @@db = SQLite3::Database.new("base.db")
    resultados=@@db.execute("SELECT path FROM rolas WHERE title LIKE '%#{titulo.to_s}%' ")
    return resultados
  end
  def busquedaPorAlbum(name)
    @@db = SQLite3::Database.new("base.db")
    resultados=@@db.execute("SELECT path FROM albums WHERE name LIKE '%#{name.to_s}%' ")
    return resultados
  end
  def busquedaPorAutor(interprete)
    @@db = SQLite3::Database.new("base.db")
    id=@@db.execute("SELECT id_performer FROM performers WHERE name LIKE '%#{interprete.to_s}%' ")
    resultados=@@db.execute("SELECT path FROM rolas WHERE id_performer=?",[id[0]])
    puts resultados
    return resultados
  end

end
