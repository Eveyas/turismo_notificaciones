# Turismo y Notificaciones

## Concepto:
Este proyecto consiste en desarrollar una mini aplicación turística llamada “Turismo & Notificaciones”. La app mostrará una lista de destinos turísticos (Cancún, Tulum, Bacalar, etc.) y permitirá al usuario recibir notificaciones locales, gestionado mediante Riverpod, incluso cuando la aplicación esté abierta

## Elaborado por:
- Laines Cupul Evelin Yasmin

## Reflexión Final

### 1. ¿Qué ventajas ofrece Riverpod frente a setState en el manejo de estado?
-Riverpod ofrece un estado más escalable y segura
-Gestiona la lógica del estado fuera de los Widgets
-La reactividad de los widgets
-No depende del contexto (BuildContext)

### 2. ¿Por qué se usan notificaciones locales junto con push notifications?
Se utilizan ambos tipos de notificaciones juntos, ya que, push puede activar una acción en la app y esta misma puede mostrar una notificación local personalizada al usuario
-Por ejemplo: en un evento remoto (push) se puede descargar la guía turística (notificación local)

### 3. ¿Cómo podrías aplicar esta lógica en una app real (p. ej. turística o educativa)?
Para la app turística:
-Riverpod: gestionaría el estado global de lugares, reservas o  rutas favoritas de los usuarios
-Notificaciones locales: mandaría un aviso al usuario, sobre un punto turístico cercano
-Push notifications: sería la encargada de informar eventos o promocionies en tiempo real al usuario, todo esto enviada desde un servidor

## Pasos para correr el Proyecto
En la terminal ingresar el comando
```
Flutter run
```
Para correr en un navegador específico (Chrome)
```
Flutter run -d chrome
```
