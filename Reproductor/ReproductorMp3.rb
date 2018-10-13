require 'fox16'
require_relative 'Minero.rb'
require_relative '../BaseDeDatos/ControlDeBase.rb'

include Fox
class ReproductorMp3 < FXMainWindow
  def initialize (app)
    super(app, "Reproductor Ruby" , :width => 1200, :height => 600| FRAME_NONE)
    hFrame2=FXHorizontalFrame.new(self,:opts => LAYOUT_FILL)
    hFrame2.backColor = "dark cyan"
    canva=FXCanvas.new(hFrame2)
    tabla=FXTable.new(self,:opts =>LAYOUT_EXPLICIT|TABLE_READONLY|TABLE_NO_COLSELECT|TABLE_COL_SIZABLE,:width=>901,:height=>400,:x=>20,:y=>20)
    tabla.selBackColor="Pink"
    tabla.rowHeaderWidth=-1
    tabla.columnHeaderHeight=25
    tabla.visibleRows = 10
    tabla.setTableSize(0,5)
    tabla.setColumnText(0,"Titulo")
    tabla.setColumnText(1,"Autor")
    tabla.setColumnText(2,"Album")
    tabla.setColumnText(3,"Genero")
    tabla.setColumnText(4,"path")
    tabla.columnHeader.setItemSize(0,300)
    tabla.columnHeader.setItemSize(1,200)
    tabla.columnHeader.setItemSize(2,200)
    tabla.columnHeader.setItemSize(3,200)
    tabla.columnHeader.setItemSize(4,0)

    tabla.connect(SEL_SELECTED) do |b|
      #puts b.anchorRow
      b.killSelection
      tabla.selectRow(b.anchorRow)
    end
    hFrame=FXHorizontalFrame.new(self,:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>490,:y=>440)
    botonMinar=FXButton.new(hFrame,"Minar")
    hFrame3=FXHorizontalFrame.new(self,:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>40,:y=>200)
    regreso=FXButton.new(hFrame3,"Regresar")
    hFrame2=FXHorizontalFrame.new(self,:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>40,:y=>440)
    botonBuscar=FXButton.new(hFrame2,"Buscar")
    botonMinar.borderWidth

    botonMinar.connect(SEL_COMMAND) do
      s=ControlDeBase.new
      s.creaBase()
      Minero.new.registraElementos()
      titulos=s.tablaGeneralTitulos
      artistas=s.tablaGeneralArtistas
      albums=s.tablaGeneralAlbum
      genero=s.tablaGeneralGenero
      path=s.tablaGeneralPath
      i=0
      e=0
      puts tabla.numRows.to_i
      puts path.length.to_i
      while i<path.length
        while e<tabla.numRows
          if path[i].to_s==tabla.getItemText(e,4).to_s and path[i].to_s!="" and tabla.getItemText(e,4).to_s!= ""
            puts path[i].to_s + "---#{e}-----"+tabla.getItemText(e,4).to_s
            e=0
            i=i+1
            next
          else
            e=e+1
          end
        end
        tabla.appendRows(1)
        tabla.setItemText(i,0,titulos[i].to_s)
        tabla.setItemText(i,1,artistas[i].to_s)
        tabla.setItemText(i,2,albums[i].to_s)
        tabla.setItemText(i,3,genero[i].to_s)
        tabla.setItemText(i,4,path[i].to_s)
        tabla.setItemJustify(i,0,FXTableItem::CENTER_X)
        tabla.setItemJustify(i,1,FXTableItem::CENTER_X)
        tabla.setItemJustify(i,2,FXTableItem::CENTER_X)
        tabla.setItemJustify(i,3,FXTableItem::CENTER_X)
        i=i+1
        e=0
      end
    end

    regreso.connect(SEL_COMMAND) do
      i=0
      while(i< tabla.numRows)
        tabla.setRowHeight(i,20)
        i=i+1
      end
    end


    botonBuscar.connect(SEL_COMMAND) do
      i=0
      while(i< tabla.numRows)
        if(tabla.getItemText(i,0) !="ERROR")
          tabla.setRowHeight(i,0)
        end
        i=i+1
      end
    end

  end
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

app = FXApp.new
ReproductorMp3.new(app)
app.create
app.run
