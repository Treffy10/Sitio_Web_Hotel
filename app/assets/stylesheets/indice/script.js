// Array de imágenes de fondo
var backgrounds = [background-image: url('fondo3.png'), background-image: url('fondo3.png'), background-image: url('fondo3.png')];
var currentIndex = 0;

// Función para cambiar el fondo de la página cada 5 segundos
function changeBackground() {
    document.body.style.backgroundImage = 'url(' + backgrounds[currentIndex] + ')';
    currentIndex = (currentIndex + 1) % backgrounds.length;
}

// Cambiar el fondo inicialmente
changeBackground();

// Cambiar el fondo cada 5 segundos
setInterval(changeBackground, 5000);
