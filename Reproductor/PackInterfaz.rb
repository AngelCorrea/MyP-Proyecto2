require_relative 'Minero.rb'
require 'fox16'
include Fox

class PackInterfaz
	def setHeaderTabla(tabla)
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
	end
	def botonMinarAccion(tabla)
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
		while i<path.length
			while e<tabla.numRows
				if path[i].to_s==tabla.getItemText(e,4).to_s and path[i].to_s!="" and tabla.getItemText(e,4).to_s!= ""
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

	def publicaEnPantalla(tabla,resultados)
		entrada=0
		i=0
		renglonesDeResultado=[]
		while resultados.length >  entrada
			if (resultados[entrada].to_s==tabla.getItemText(i,4).to_s)
				entrada=1+entrada
				renglonesDeResultado.push(i)
				i=0
			else
				i=1+i
			end
		end
		k=0
		while tabla.numRows > k
			if renglonesDeResultado.include?(k)
				tabla.setRowHeight(k,20)
			else
				tabla.setRowHeight(k,0)
			end
			k=k+1
		end
	end

	def busquedaInterfaz(entradaDeBusqueda,tabla)
		if(entradaDeBusqueda.text=="")
			#Regresa a su tamaño las tablas ocultas
			i=0
			while(i< tabla.numRows)
				tabla.setRowHeight(i,20)
				i=i+1
			end
		else
			texto=entradaDeBusqueda.text
			resultados=[]
			subTexto=[]
			subTexto=texto.split(',')
			k=0
			while k<subTexto.length
				if(subTexto[k].include?"T:")
					cadenaBusquedaTitulo=subTexto[k].split("T:")
					resultadosTitulo=ControlDeBase.new.busquedaPorTitulo(cadenaBusquedaTitulo[1])
					if resultados.empty?
						resultados=resultadosTitulo
					else
						resultados=resultados &resultadosTitulo
					end
				elsif (subTexto[k].include?"I:")
					cadenaBusquedaInterprete=subTexto[k].split("I:")
					resultadosInterprete=ControlDeBase.new.busquedaPorAutor(cadenaBusquedaInterprete[1])
					if(resultados.empty?)
						resultados=resultadosInterprete
					else
						resultados=resultados & resultadosInterprete
					end
				elsif(subTexto[k].include?"A:")
					cadenaBusquedaAlbum=subTexto[k].split("A:")
					resultadosAlbum=ControlDeBase.new.busquedaPorAlbum(cadenaBusquedaAlbum[1])
					if(resultados.empty?)
						resultados=resultadosAlbum
					else
						resultados= resultados & resultadosAlbum
					end
				end
				k=k+1
			end
			PackInterfaz.new.publicaEnPantalla(tabla,resultados)
		end
	end

	def ventanaDeModificacion(app,pathRenglon)
		configRola=FXDialogBox.new(app,"Editar Interprete",:width=>600,:height=>300)
		configRola.backColor="SteelBlue"
		buttons = FXHorizontalFrame.new(configRola,:opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH)
		buttons.backColor="SkyBlue"
	 	FXButton.new(buttons, "OK",:target => configRola, :selector => FXDialogBox::ID_ACCEPT,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X)
	 	FXButton.new(buttons, "Cancel",:target => configRola, :selector => FXDialogBox::ID_CANCEL,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X)

		tabbook = FXTabBook.new(configRola, :opts => LAYOUT_FILL)
		tabbook.backColor="SkyBlue"
		PackInterfaz.new.tabBookPersona(tabbook)
		PackInterfaz.new.tabBookGrupo(tabbook)

		 configRola.execute
	end

	def tabBookPersona(tabbook)
		personaTab = FXTabItem.new(tabbook, " Persona ")
		personaPage = FXVerticalFrame.new(tabbook,
		:opts => FRAME_RAISED|LAYOUT_FILL)
		personaPage.backColor="CadetBlue"
		personaTab.backColor="CadetBlue"
		form = FXMatrix.new(personaPage, 2,
		 :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X)
	 FXLabel.new(form, "Nombre Artístico:")
	 FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		 :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 FXLabel.new(form, "Nombre Real:")
	 FXTextField.new(form, 20,:selector => FXDataTarget::ID_VALUE,
		 :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 FXLabel.new(form, "Fecha de Nacimiento:")
	 FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		 :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 FXLabel.new(form, "Fecha de muerte:")
	 FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		 :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	end

	def tabBookGrupo(tabbook)
		grupoTab = FXTabItem.new(tabbook, " Grupo ")
		grupoPage = FXVerticalFrame.new(tabbook,
		:opts => FRAME_RAISED|LAYOUT_FILL)
		grupoTab.backColor="palevioletred"
		grupoPage.backColor="palevioletred"

		form = FXMatrix.new(grupoPage, 2,
		:opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X)
		FXLabel.new(form, "Nombre:")
		FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
		FXLabel.new(form, "Fecha de inicio:")
		FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
		FXLabel.new(form, "Fecha final:")
		FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
		:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	end
end
