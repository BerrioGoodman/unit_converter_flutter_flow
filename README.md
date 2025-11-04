

# 📱 Flutter Unit Converter

Aplicación móvil desarrollada en Flutter que permite realizar conversiones entre distintas unidades de longitud, peso, temperatura y monedas.
Incluye autenticación de usuarios con registro e inicio de sesión, utilizando una base de datos SQLite local.
Además, la app guarda un historial persistente de conversiones utilizando SharedPreferences.

---

# ✨ Características

🔄 Conversión entre diferentes unidades de longitud, peso, temperatura y monedas.

💱 Conversión de monedas en tiempo real utilizando API externa (Free Currency API).

👤 Sistema de autenticación de usuarios con registro e inicio de sesión.

🗄️ Base de datos SQLite local para gestión de usuarios.

📜 Historial persistente de conversiones (hasta 50 registros).

🎨 Interfaz amigable con colores pastel y navegación intuitiva.

📱 Diseñada con arquitectura simple, separando el código en:

models → estructuras de datos.

services → lógica de negocio, persistencia y APIs externas.

screens → pantallas principales de la app.

---
# 📂 Estructura del Proyecto

lib/

│

├── models/

│   ├── conversion\_history.dart            # Modelo para historial de conversiones

│   ├── conversion\_rates.dart              # Tasas de conversión de longitud/peso

│   ├── temperature\_units.dart             # Lista de unidades de temperatura

│   ├── weight\_units.dart                  # Lista de unidades de peso

│   ├── currency\_units.dart                # Lista de monedas disponibles

│   ├── exchange\_rates.dart                # Modelo para tasas de cambio de monedas

│   └── user.dart                           # Modelo para usuarios

│


├── services/

│   ├── conversion\_service.dart           # Lógica de conversión (longitud, peso, temperatura)

│   ├── preferences\_service.dart          # Manejo de historial con SharedPreferences

│   ├── currency\_service.dart             # Servicio para conversión de monedas y API externa

│   └── database\_helper.dart              # Gestión de base de datos SQLite para usuarios

│


└── screens/

├── home\_screen.dart                      # Pantalla principal con BottomNavigationBar

├── login\_screen.dart                     # Pantalla de inicio de sesión

├── register\_screen.dart                  # Pantalla de registro de usuarios

├── profile\_screen.dart                   # Pantalla de perfil de usuario

├── length\_converter\_screen.dart         # Conversor de longitud

├── weight\_converter\_screen.dart         # Conversor de peso

├── temperature\_converter\_screen.dart    # Conversor de temperatura

├── currency\_converter\_screen.dart       # Conversor de monedas

└── history\_screen.dart                   # Historial de conversiones
---

# 🛠️ Modelos

## ConversionHistory

Representa una conversión realizada por el usuario.

### Contiene:

type → tipo de conversión (length, weight, temperature).

inputValue → valor de entrada.

fromUnit / toUnit → unidades.

result → resultado de la conversión.

timestamp → fecha y hora de la conversión.

## conversion\_rates

### Mapa con tasas de conversión relativas a una unidad base.

Ejemplo:

{

"Kilómetros": 1000,

"Metros": 1,

"Centímetros": 0.01,

...

}

## temperature\_units

### Lista de unidades de temperatura disponibles:

Celsius 🌡️

Fahrenheit 🔥

Kelvin ❄️

## weight\_units

### Lista de unidades de peso disponibles:

Kilogramos, Gramos, Libras, Onzas, etc.

## currency\_units

### Lista de monedas disponibles con símbolos y nombres:

USD (US Dollar), EUR (Euro), GBP (British Pound), JPY (Japanese Yen), CAD (Canadian Dollar), AUD (Australian Dollar), CHF (Swiss Franc), CNY (Chinese Yuan), MXN (Mexican Peso), BRL (Brazilian Real).

## exchange\_rates

### Modelo para manejar tasas de cambio de monedas desde API externa.

Contiene:

rates → mapa de tasas de cambio.

base → moneda base (USD).

timestamp → fecha y hora de la última actualización.

## user

### Modelo para usuarios de la aplicación.

Contiene:

id → identificador único.

username → nombre de usuario único.

password → contraseña (almacenada como texto plano para simplicidad).

---

# 🔌 API Externa

## Currency Service

La aplicación utiliza la **Free Currency API** para obtener tasas de cambio en tiempo real.

### Endpoint utilizado:

`https://api.freecurrencyapi.com/v1/latest?apikey={API_KEY}&base_currency=USD`

### Características:

- Tasas de cambio actualizadas periódicamente.

- Cache local para evitar llamadas excesivas a la API (válido por 1 hora).

- Manejo de errores de conexión y respuestas inválidas.

---

# 🗄️ Base de Datos

## SQLite Database

La aplicación utiliza **SQLite** para el almacenamiento local de usuarios.

### Tabla: users

| Campo     | Tipo    | Descripción              |
|-----------|---------|--------------------------|
| id        | INTEGER | Primary Key Autoincrement|
| username  | TEXT    | Nombre de usuario único  |
| password  | TEXT    | Contraseña del usuario   |

### Operaciones soportadas:

- Insertar usuario (registro).

- Obtener usuario por credenciales (login).

- Verificar si username está disponible.

- Listar todos los usuarios.

- Actualizar usuario.

- Eliminar usuario.

---

# ⚙️ Servicios

## ConversionService

convert(value, fromUnit, toUnit, rates) → convierte longitudes/pesos usando factores.

convertTemperature(value, fromUnit, toUnit) → convierte temperaturas con fórmulas.

## PreferencesService

saveConversion(conversion) → guarda una conversión en historial.

getConversionHistory() → retorna lista de conversiones almacenadas.

clearHistory() → elimina todo el historial.

## CurrencyService

fetchExchangeRates(base) → obtiene tasas de cambio desde API externa.

convertCurrency(amount, fromCurrency, toCurrency, rates) → convierte entre monedas.

getCachedOrFetchRates(base) → retorna tasas cacheadas o obtiene nuevas si expiraron.

## DatabaseHelper

Singleton para gestión de base de datos SQLite.

insertUser(user) → registra nuevo usuario.

getUser(username, password) → autentica usuario.

isUsernameTaken(username) → verifica disponibilidad de username.

getAllUsers() → lista todos los usuarios.

updateUser(user) → actualiza datos de usuario.

deleteUser(id) → elimina usuario.

---

# 🖼️ Pantallas

## 🔹 HomeScreen

Pantalla principal con BottomNavigationBar para moverse entre conversores, historial y perfil.

Requiere autenticación para acceder.

## 🔹 LoginScreen

Pantalla de inicio de sesión con campos para username y password.

Valida credenciales contra la base de datos.

Navega a registro si no tiene cuenta.

## 🔹 RegisterScreen

Pantalla de registro de nuevos usuarios.

Valida que el username no esté tomado.

Almacena usuario en base de datos SQLite.

## 🔹 ProfileScreen

Muestra información del usuario actual.

Permite cerrar sesión.

## 🔹 LengthConverterScreen

Permite convertir entre unidades de longitud con inputs, dropdowns y resultado estilizado en una card.

## 🔹 WeightConverterScreen

Pantalla similar para peso (estructura equivalente a longitud).

## 🔹 TemperatureConverterScreen

Convierte entre Celsius, Fahrenheit y Kelvin.

Incluye íconos personalizados para cada unidad.

## 🔹 CurrencyConverterScreen

Convierte entre diferentes monedas utilizando tasas de cambio en tiempo real.

Muestra timestamp de última actualización.

Incluye íconos y símbolos de monedas.

## 🔹 HistoryScreen

Muestra el historial de conversiones guardadas.

Opciones:

Ver lista de conversiones recientes.

Refrescar historial.

Limpiar historial con confirmación.

---

# 🚀 Instalación y Uso

### Clonar el repositorio:

git clone https://github.com/tuusuario/flutter-unit-converter.git


### Instalar dependencias:

flutter pub get


### Ejecutar la app:

flutter run

# 📦 Dependencias Principales

flutter/material.dart → UI y widgets.

shared\_preferences → almacenamiento local de historial.

http → cliente HTTP para llamadas a APIs externas.

sqflite → base de datos SQLite local.

path → utilidades para manejo de rutas de archivos.
