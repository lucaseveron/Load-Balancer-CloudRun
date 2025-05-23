# Usa una imagen base de Python
FROM python:3.10-slim

# Crea un directorio de trabajo
WORKDIR /app

# Copia dependencias
COPY requirements.txt .

# Instala dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código
COPY . .

# Expone el puerto
EXPOSE 8080

# Comando de ejecución (usa gunicorn con Flask)
CMD ["gunicorn", "-b", ":8080", "main:app"]


