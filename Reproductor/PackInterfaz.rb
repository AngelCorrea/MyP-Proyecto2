require_relative 'Minero.rb'
require_relative '../BaseDeDatos/ControlDeBase.rb'
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
		tabla.columnHeader.setItemSize(0,405)
		tabla.columnHeader.setItemSize(1,235)
		tabla.columnHeader.setItemSize(2,230)
		tabla.columnHeader.setItemSize(3,230)
		tabla.columnHeader.setItemSize(4,-1)
	end

	def botonMinarAccion(tabla)
		s=ControlDeBase.new
		s.creaBase()
		elementos=Minero.new.cuentaElementos()
		Minero.new.registraElementos()
		titulos=s.tablaGeneralTitulos
		artistas=s.tablaGeneralArtistas
		albums=s.tablaGeneralAlbum
		genero=s.tablaGeneralGenero
		path=s.tablaGeneralPath
		i=0
		e=0
		count=0.0
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
			if(!path[i].nil?)
				tabla.appendRows(1)
				tabla.setItemText(i,0,titulos[i][0].to_s)
				tabla.setItemText(i,1,artistas[i][0].to_s)
				tabla.setItemText(i,2,albums[i][0].to_s)
				tabla.setItemText(i,3,genero[i][0].to_s)
				tabla.setItemText(i,4,path[i].to_s)
				tabla.setItemJustify(i,0,FXTableItem::LEFT)
				tabla.setItemJustify(i,1,FXTableItem::LEFT)
				tabla.setItemJustify(i,2,FXTableItem::LEFT)
				tabla.setItemJustify(i,3,FXTableItem::LEFT)
				i=i+1
				e=0
			end
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
	 	FXButton.new(buttons, "Salir",:target => configRola, :selector => FXDialogBox::ID_CANCEL,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X)

		tabbook = FXTabBook.new(configRola, :opts => LAYOUT_FILL)
		tabbook.backColor="SkyBlue"

		PackInterfaz.new.tabBookPersona(tabbook,pathRenglon,configRola)
		PackInterfaz.new.tabBookGrupo(tabbook,pathRenglon,configRola,app)

		 configRola.execute
	end

	def tabBookPersona(tabbook,pathRenglon,configRola)
		personaTab = FXTabItem.new(tabbook, " Persona ")
		personaPage = FXVerticalFrame.new(tabbook,
		:opts => FRAME_RAISED|LAYOUT_FILL)
		personaPage.backColor="CadetBlue"
		personaTab.backColor="CadetBlue"
		form = FXMatrix.new(personaPage, 2,
		 :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X)

	 	pathRenglon=pathRenglon.delete "["
	 	pathRenglon=pathRenglon.delete"]"
	 	pathRenglon=pathRenglon.delete"\""

	 	idPerformer=ControlDeBase.new.buscaPorPath(pathRenglon)
 	 	nombrePerformer=ControlDeBase.new.buscaPorId_Performer(idPerformer)
	 	ControlDeBase.new.buscarIdentificados("persons",nombrePerformer[0][0])

	 	FXLabel.new(form, "Nombre Artístico:")
	 	FXLabel.new(form, nombrePerformer[0][0])
	 	FXLabel.new(form, "Nombre Real:")
	 	nombreReal=FXTextField.new(form, 20,:selector => FXDataTarget::ID_VALUE,
			:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 	FXLabel.new(form, "Fecha de Nacimiento:")
	 	fechaNacimiento=FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
	 	:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 	FXLabel.new(form, "Fecha de muerte:")
		fechaMuerte =FXTextField.new(form, 20, :selector => FXDataTarget::ID_VALUE,
			:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
		botonAceptar=FXButton.new(personaPage, "Guardar",:target => configRola, :selector => FXDialogBox::ID_ACCEPT,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X)
		reconocido=ControlDeBase.new. buscarIdentificados("persons",nombrePerformer[0][0])
		 if(!reconocido[0].nil?)
		  	nombreReal.text=reconocido[0][2]
				fechaNacimiento.text=reconocido[0][3]
		 		fechaMuerte.text=reconocido[0][4]
				tabbook.connect(SEL_COMMAND) do
					tabbook.setCurrent(0,true)
				end
			end
			botonAceptar.connect(SEL_COMMAND) do
			if(reconocido[0].nil?)
				ControlDeBase.new.registrarPersona(nombrePerformer[0][0],nombreReal.text,fechaNacimiento.text,fechaMuerte.text)
				ControlDeBase.new.actualizarDatoIdType(0,nombrePerformer[0][0])
			else
				ControlDeBase.new.actualizaArtista(nombrePerformer[0][0],nombreReal.text,fechaNacimiento.text,fechaMuerte.text)
			end
			botonAceptar.hide
			nombreReal.backColor="gray"
			fechaNacimiento.backColor="gray"
			fechaMuerte.backColor="Gray"
			nombreReal.editable=false
  		fechaNacimiento.editable=false
			fechaMuerte.editable=false
				tabbook.connect(SEL_COMMAND) do
				tabbook.setCurrent(0,true)
			end
 		end
	end


	def tabBookGrupo(tabbook,pathRenglon,configRola,app)
		grupoTab = FXTabItem.new(tabbook, " Grupo ")
		grupoPage = FXVerticalFrame.new(tabbook,:opts => FRAME_RAISED|LAYOUT_FILL)
		grupoTab.backColor="palevioletred"
		grupoPage.backColor="palevioletred"

		form = FXMatrix.new(grupoPage, 2,
		:opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X)
		pathRenglon=pathRenglon.delete "["
		pathRenglon=pathRenglon.delete"]"
		pathRenglon=pathRenglon.delete"\""

		idPerformer=ControlDeBase.new.buscaPorPath(pathRenglon)
		nombrePerformer=ControlDeBase.new.buscaPorId_Performer(idPerformer)

		FXLabel.new(form, "Nombre:")
		FXLabel.new(form, nombrePerformer[0][0])

		FXLabel.new(form, "Fecha de inicio:")
		fechaInicio=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
		FXLabel.new(form, "Fecha final:")
		fechaFinal=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
		botonAceptar=FXButton.new(grupoPage," Guardar ",:opts => LAYOUT_EXPLICIT|BUTTON_NORMAL,:width=>80,:height=>30,:x=>200,:y=>150)

		botonAgregarPersona=FXButton.new(grupoPage,"Agregar\nIntegrantes",:opts => LAYOUT_EXPLICIT|BUTTON_NORMAL,:width=>80,:height=>40,:x=>300,:y=>150)
		botonAgregarPersona.hide
		reconocido=ControlDeBase.new. buscarIdentificados("groups",nombrePerformer[0][0])
		if(!reconocido[0].nil?)
			tabbook.setCurrent(1,true)
			fechaInicio.text=reconocido[0][2]
			fechaFinal.text=reconocido[0][3]
			botonAgregarPersona.show
			tabbook.connect(SEL_COMMAND) do
				tabbook.setCurrent(1,true)
			end
		end

		botonAgregarPersona.connect (SEL_COMMAND) do
			PackInterfaz.new.registrarPersonaEnGrupo(app,nombrePerformer[0][0])
		end

		botonAceptar.connect(SEL_COMMAND) do
			if(reconocido[0].nil?)
				ControlDeBase.new.registrarGrupo(nombrePerformer[0][0],fechaInicio.text,fechaFinal.text)
 				ControlDeBase.new.actualizarDatoIdType(1,nombrePerformer[0][0])
			else
				ControlDeBase.new.actualizaBanda(nombrePerformer[0][0],fechaInicio.text,fechaFinal.text)
			end
		 	botonAceptar.hide
		 	fechaInicio.backColor="gray"
		 	fechaFinal.backColor="gray"
		 	fechaInicio.editable=false
		 	fechaFinal.editable=false
		 	tabbook.connect(SEL_COMMAND) do
			 	tabbook.setCurrent(1,true)
		 end
	 end
	end

	def registrarPersonaEnGrupo(app,nombreGrupo)
		registro=FXDialogBox.new(app,"Agregar Integrantes",:width=>300,:height=>400)
		botones=FXVerticalFrame.new(registro,:opts => FRAME_RAISED|LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X)


		artistas=FXListBox.new(registro,:opts => LISTBOX_NORMAL|LAYOUT_EXPLICIT|FRAME_THICK,:width=>270,:height=>30,:x=>20,:y=>100)

		botonAgregaIntegrante=FXButton.new(botones, " Agregar Integrante ",:opts => BUTTON_NORMAL|LAYOUT_FILL_X)
		botonAgregaIntegrante.backColor="DodgerBlue"
		botonGuardar=FXButton.new(botones, "Guardar",:opts => BUTTON_NORMAL|LAYOUT_FILL_X)
		salida=FXButton.new(botones, "Salir",:target => registro,
			:selector => FXDialogBox::ID_CANCEL,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X|LAYOUT_FILL_X)

			salida.backColor="IndianRed"
			botonGuardar.backColor="PaleGreen"
			FXLabel.new(registro,"Grupo: "+nombreGrupo,:opts=>LAYOUT_CENTER_X,:y=>20)
			listaIntegrantes=FXText.new(registro,:opts=>LAYOUT_EXPLICIT|TEXT_READONLY,:width=>200,:height=>150,:x=>20,:y=>140)


			ids=ControlDeBase.new.buscarIdentificados("groups",nombreGrupo)
			identificados=ControlDeBase.new.buscarIdentificadosCompleto("persons")
			enGrupo=ControlDeBase.new.busquedaInGrup(ids[0][0])
			listaEnElGrupo="Integrantes: \n"
			if(!enGrupo.nil?)
				i=0
				e=0
				aux=identificados
				while e<enGrupo.length
					if(aux[i][0]==enGrupo[e][0])
						listaEnElGrupo=listaEnElGrupo+aux[i][1].to_s+"\n"
						identificados.delete(identificados[i])
						i=0
						e=e+1
					else
						i=1+i
					end
				end
			end

			botonAgregaIntegrante.connect(SEL_COMMAND) do
				PackInterfaz.new.ventanaRegistroPersona(app,nombreGrupo)
			end

			listaIntegrantes.text=listaEnElGrupo
			artistas.appendItem(" ")
			identificados.each{|nombre| artistas.appendItem(nombre[1])}
			botonGuardar.connect(SEL_COMMAND) do
				if(artistas.currentItem!=0)
					personaAgregar=artistas.getItem(artistas.currentItem)
					ControlDeBase.new.personaEnGrupo(personaAgregar,nombreGrupo)
					botonGuardar.hide
				end
			end
		registro.execute
	end

	def ventanaRegistroPersona(app,nombreGrupo)
		ventanaRegistro=FXDialogBox.new(app,"Registra Integrantes",:width=>600,:height=>400)

		botones=FXVerticalFrame.new(ventanaRegistro,:opts => FRAME_RAISED|LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X)
		botonAceptar=FXButton.new(botones, "Guardar",:opts => BUTTON_NORMAL|LAYOUT_CENTER_X|LAYOUT_FILL_X)
		salida=FXButton.new(botones, "Salir",:target => ventanaRegistro,
			:selector => FXDialogBox::ID_CANCEL,:opts => BUTTON_NORMAL|LAYOUT_CENTER_X|LAYOUT_FILL_X)

			form = FXMatrix.new(ventanaRegistro, 2,
			 :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X)
			 FXLabel.new(form, "Nombre Artístico:")
			 nombreStage=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
				FXLabel.new(form, "Nombre Real:")
	 	 	nombreReal=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 	 	FXLabel.new(form, "Fecha de Nacimiento:")
	 	 	fechaNacimiento=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	 	 	FXLabel.new(form, "Fecha de muerte:")
			fechaMuerte=FXTextField.new(form, 20,:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
			botonAceptar.connect(SEL_COMMAND) do
				if(nombreStage.text=="")
					FXMessageBox.error(app,MBOX_OK,"Entrada Invalida","El Nombre artistico no debe ser vacio")
					nombreStage.backColor="OrangeRed"
				else
					botonAceptar.hide
					nombreStage.backColor="Gray"
					nombreReal.backColor="gray"
					fechaNacimiento.backColor="gray"
					fechaMuerte.backColor="Gray"
					nombreStage.editable=false
					nombreReal.editable=false
		  		fechaNacimiento.editable=false
					fechaMuerte.editable=false
					ControlDeBase.new.registrarPersona(nombreStage.text,nombreReal.text,fechaNacimiento.text,fechaMuerte.text)
					ControlDeBase.new.personaEnGrupo(nombreStage.text,nombreGrupo)
				end
			end
		ventanaRegistro.execute
	end
end
