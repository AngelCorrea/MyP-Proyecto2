require_relative 'Minero.rb'

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


end
