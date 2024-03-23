# Lo que primeramente hace este controller es calcular la duracion de estadia de las fechas elegidas para asi pasar este valor a la ruta
# de /reservas.
# Cuando creas una instancia variable usando el @, esta se podra usar en cualquier metodo de solo esta clase y conservara su valor dado.
# Al querer usar esa variable instancia en la vista de este controlller no hace falta escribirlo con el @

class IndiceController < ApplicationController
  def index
  end
end
