require "minitest/autorun"
require "../Reproductor/Minero.rb"
require '../Reproductor/JuntaEtiquetas.rb'

class TestConteo < Minitest::Test
  def test_CuentaElementos
    elementos=26
    elementosContados=Minero.new.cuentaElementos()
    assert_equal(elementos,elementosContados)
  end

end
