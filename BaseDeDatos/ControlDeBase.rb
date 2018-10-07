require 'sqlite3'

class ControlDeBase
  @@count=0
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
          title TEXT
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
    @@count=@@count+1
    album=objetoRola.nombreAlbum
    noAlbum=objetoRola.noAlbum
    año=objetoRola.año

    nombreInterprete=objetoRola.inter
    @@db = SQLite3::Database.new("base.db")
    @@db.execute("INSERT INTO albums VALUES ( ?, ? ,?,?);",[@@count,"path",album,año])
    @@db.execute("INSERT INTO performers VALUES ( ? ,?,?);",[@@count,0,nombreInterprete])
  end
end
