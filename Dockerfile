FROM python:3.12-slim

# Evita que Python genere archivos .pyc y permite ver logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalación de dependencias del sistema necesarias para algunas librerías de Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia e instalación de requerimientos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la aplicación y archivos necesarios
COPY app ./app
# Copiamos también los tests y archivos de configuración raíz si existen
COPY pytest.ini .env.example* ./ 

# Variables de entorno por defecto
ENV APP_HOST=0.0.0.0
ENV APP_PORT=8000
ENV DATABASE_URL=sqlite:///./vankenban.db

EXPOSE 8000

# Comando unificado y corregido
# Nota: Se recomienda usar un script de inicio si necesitas correr migraciones antes de iniciar
CMD ["sh", "-c", "uvicorn app.main:app --host ${APP_HOST} --port ${APP_PORT}"]