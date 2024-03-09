document.addEventListener("DOMContentLoaded", function() {
    const fechaEntrada = document.getElementById('fecha_entrada');
    const fechaSalida = document.getElementById('fecha_salida');
    const botonBuscar = document.querySelector('.boton_buscar input[type="submit"]');
  
    // Evento al hacer clic en el botón de búsqueda
    botonBuscar.addEventListener('click', function(event) {
      fechaEntrada.blur(); // Quitar el foco del campo de fecha de entrada
      fechaSalida.blur(); // Quitar el foco del campo de fecha de salida
    });
  
    // Evento al hacer clic en el campo de fecha de entrada
    fechaEntrada.addEventListener('click', function(event) {
      fechaSalida.blur(); // Quitar el foco del campo de fecha de salida
    });
  
    // Evento al hacer clic en el campo de fecha de salida
    fechaSalida.addEventListener('click', function(event) {
      fechaEntrada.blur(); // Quitar el foco del campo de fecha de entrada
    });
  
    // Evitar la entrada de teclado en el campo de fecha de entrada
    fechaEntrada.addEventListener('keydown', function(event) {
      event.preventDefault();
    });
  
    // Evitar la entrada de teclado en el campo de fecha de salida
    fechaSalida.addEventListener('keydown', function(event) {
      event.preventDefault();
    });
  });