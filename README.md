

📱 Flutter Unit Converter

Aplicación móvil desarrollada en Flutter que permite realizar conversiones entre distintas unidades de longitud, peso y temperatura.

Además, la app guarda un historial persistente de conversiones utilizando SharedPreferences.

✨ Características

🔄 Conversión entre diferentes unidades de longitud, peso y temperatura.

📜 Historial persistente de conversiones (hasta 50 registros).

🎨 Interfaz amigable con colores pastel y navegación intuitiva.

📱 Diseñada con arquitectura simple, separando el código en:

models → estructuras de datos.

services → lógica de negocio y persistencia.

screens → pantallas principales de la app.

📂 Estructura del Proyecto

lib/

│

├── models/

│   ├── conversion\_history.dart    # Modelo para historial de conversiones

│   ├── conversion\_rates.dart      # Tasas de conversión de longitud/peso

│   └── temperature\_units.dart     # Lista de unidades de temperatura

│

├── services/

│   ├── conversion\_service.dart    # Lógica de conversión (longitud, peso, temperatura)

│   └── preferences\_service.dart   # Manejo de historial con SharedPreferences

│

└── screens/

├── home\_screen.dart           # Pantalla principal con BottomNavigationBar

├── length\_converter\_screen.dart # Conversor de longitud

├── weight\_converter\_screen.dart # Conversor de peso

├── temperature\_converter\_screen.dart # Conversor de temperatura

└── history\_screen.dart        # Historial de conversiones

🛠️ Modelos

ConversionHistory

Representa una conversión realizada por el usuario.

Contiene:

type → tipo de conversión (length, weight, temperature).

inputValue → valor de entrada.

fromUnit / toUnit → unidades.

result → resultado de la conversión.

timestamp → fecha y hora de la conversión.

conversion\_rates

Mapa con tasas de conversión relativas a una unidad base.

Ejemplo:

{

"Kilómetros": 1000,

"Metros": 1,

"Centímetros": 0.01,

...

}

temperature\_units

Lista de unidades de temperatura disponibles:

Celsius 🌡️

Fahrenheit 🔥

Kelvin ❄️

⚙️ Servicios

ConversionService

convert(value, fromUnit, toUnit, rates) → convierte longitudes/pesos usando factores.

convertTemperature(value, fromUnit, toUnit) → convierte temperaturas con fórmulas.

PreferencesService

saveConversion(conversion) → guarda una conversión en historial.

getConversionHistory() → retorna lista de conversiones almacenadas.

clearHistory() → elimina todo el historial.

🖼️ Pantallas

🔹 HomeScreen

Pantalla principal con BottomNavigationBar para moverse entre conversores y el historial.

🔹 LengthConverterScreen

Permite convertir entre unidades de longitud con inputs, dropdowns y resultado estilizado en una card.

🔹 WeightConverterScreen

Pantalla similar para peso (estructura equivalente a longitud).

🔹 TemperatureConverterScreen

Convierte entre Celsius, Fahrenheit y Kelvin.

Incluye íconos personalizados para cada unidad.

🔹 HistoryScreen

Muestra el historial de conversiones guardadas.

Opciones:

Ver lista de conversiones recientes.

Refrescar historial.

Limpiar historial con confirmación.

🚀 Instalación y Uso

Clonar el repositorio:

git clone https://github.com/tuusuario/flutter-unit-converter.git


Instalar dependencias:

flutter pub get


Ejecutar la app:

flutter run

📦 Dependencias Principales

flutter/material.dart

→ UI y widgets.

shared\_preferences

→ almacenamiento local de historial.
