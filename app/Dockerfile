# Usa imagen base de Python
FROM python:3.11-slim

# Establece directorio de trabajo
WORKDIR /app

# Copia los archivos de la app
COPY . .

# Instala Flask
RUN pip install flask

# Define puerto por defecto
EXPOSE 8080

# Comando para correr la app
CMD ["python", "app.py"]
