# Use a lightweight Node.js image as the base image
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --verbose  # Added verbose flag for debugging

# Copy the rest of the application files
COPY . .

# Build the Vite app
RUN npm run build

# Debugging step to check if build produces dist folder
RUN ls -la /app/dist  # Verify dist folder

# Use a lightweight web server to serve the built app
FROM nginx:alpine

# Copy the built files to Nginx's default HTML directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Debugging step to ensure files are copied to Nginx
RUN ls -la /usr/share/nginx/html  # Verify files are in the right location

# Expose the default Nginx port
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
