require 'fox16'
require_relative 'PackInterfaz.rb'
require_relative '../BaseDeDatos/ControlDeBase.rb'

include Fox

class ReproductorMp3 < FXMainWindow
  def initialize (app)
    super(app, "Reproductor Ruby" , :width => 1200, :height => 600 |FRAME_NONE)

    @app=app
    icono=FXPNGIcon.new(app,File.open("RecursosInterfaz/IconoApp.png","rb").read)
    self.icon=icono

    hFrame2=FXHorizontalFrame.new(self,:opts => LAYOUT_FILL)
    entradaDeBusqueda=FXTextField.new(self,200,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>300,:height=>30,:x=>70,:y=>20)
    hFrame2.backColor = "dark cyan"
    tabla=FXTable.new(self,:opts =>LAYOUT_EXPLICIT|TABLE_READONLY|TABLE_NO_COLSELECT|TABLE_COL_SIZABLE,:width=>1101,:height=>470,:x=>20,:y=>70)
    PackInterfaz.new.setHeaderTabla(tabla)

    if(File.exists?("../BaseDeDatos/base.db"))
      PackInterfaz.new.botonMinarAccion(tabla)
    end

    tabla.connect(SEL_DOUBLECLICKED) do |b|
      ##Entrada para modificar
      tabla.selectRow(b.anchorRow)
      pathRenglon=tabla.getItemText(b.anchorRow,4)
      PackInterfaz.new.ventanaDeModificacion(self,pathRenglon)
    end


    iconoPico=FXPNGIcon.new(app,File.open("RecursosInterfaz/pico2.png","rb").read)
    iconoLupa=FXPNGIcon.new(app,File.open("RecursosInterfaz/lupa.png","rb").read)
    lupa=FXLabel.new(self,"",:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>20,:y=>20)
    lupa.icon=iconoLupa
    lupa.backColor="dark cyan"
    botonMinar=FXButton.new(self,"Minar",:opts => LAYOUT_EXPLICIT|BUTTON_NORMAL,:width=>80,:height=>40,:x=>1090,:y=>20)
    botonMinar.icon=iconoPico

    botonMinar.connect(SEL_COMMAND) do
      Thread.new{PackInterfaz.new.botonMinarAccion(tabla)}
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
