# ===============================
# 1) Etapa de Build (Vite)
# ===============================
FROM node:20-alpine AS builder
WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar todo el proyecto
COPY . .

# Construir para producción
RUN npm run build

# ===============================
# 2) Etapa de producción (Nginx)
# ===============================
FROM nginx:stable-alpine AS production

# Copiar el build final de Vite a la carpeta pública de nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer puerto 80 (HTTP)
EXPOSE 80

# Iniciar nginx en modo foreground
CMD ["nginx", "-g", "daemon off;"]
