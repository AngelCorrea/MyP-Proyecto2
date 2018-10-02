require "find"
class Minero
  def cuentaElementos
    elementos=0
    Find.find('../MusicaEjemplo/') do |f|
      case
      when File.file?(f)
        then elementos=elementos+1
      end
    end
    return elementos
  end
end

Minero.new.cuentaElementos()
