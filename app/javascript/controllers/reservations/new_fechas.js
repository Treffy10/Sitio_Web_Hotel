document.addEventListener("DOMContentLoaded", function() {
  const fechaEntradaInput = document.getElementById('fecha_entrada');
  const fechaSalidaInput = document.getElementById('fecha_salida');

  // Configurar fecha mínima para la fecha de salida basada en la fecha de entrada
  fechaEntradaInput.addEventListener('input', function() {
    fechaSalidaInput.min = fechaEntradaInput.value;
  });

  // Validar fechas antes de enviar el formulario
  const formulario = document.getElementById('formulario');
  formulario.addEventListener('submit', function(event) {
    const fechaEntrada = new Date(fechaEntradaInput.value);
    const fechaSalida = new Date(fechaSalidaInput.value);

    if (fechaSalida <= fechaEntrada) {
      event.preventDefault();
      if (fechaSalida.getTime() === fechaEntrada.getTime()) {
        alert('La fecha de salida debe ser posterior y diferente a la fecha de entrada.');
      } else {
        alert('La fecha de salida debe ser posterior a la fecha de entrada.');
      }
    }
  });
});