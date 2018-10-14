require 'fox16'
require_relative 'PackInterfaz.rb'
require_relative '../BaseDeDatos/ControlDeBase.rb'

include Fox
class ReproductorMp3 < FXMainWindow
  def initialize (app)
    super(app, "Reproductor Ruby" , :width => 1200, :height => 600| FRAME_NONE)
    icono=FXPNGIcon.new(app,File.open("RecursosInterfaz/IconoApp.png","rb").read)
    self.icon=icono
    puts self.title
    hFrame2=FXHorizontalFrame.new(self,:opts => LAYOUT_FILL)
    entradaDeBusqueda=FXTextField.new(self,100,:opts=>LAYOUT_EXPLICIT,:width=>100,:height=>30,:x=>20,:y=>500)
    hFrame2.backColor = "dark cyan"
    tabla=FXTable.new(self,:opts =>LAYOUT_EXPLICIT|TABLE_READONLY|TABLE_NO_COLSELECT|TABLE_COL_SIZABLE,:width=>901,:height=>400,:x=>20,:y=>20)
    PackInterfaz.new.setHeaderTabla(tabla)

    tabla.connect(SEL_SELECTED) do |b|
      #POR ARREGLAR-----------------------
      b.killSelection
      tabla.selectRow(b.anchorRow)
    end
    hFrame=FXHorizontalFrame.new(self,:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>490,:y=>440)
    botonMinar=FXButton.new(hFrame,"Minar")

    botonMinar.connect(SEL_COMMAND) do
      PackInterfaz.new.botonMinarAccion(tabla)
    end

    entradaDeBusqueda.connect(SEL_COMMAND) do
      PackInterfaz.new.busquedaInterfaz(entradaDeBusqueda,tabla)
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
