# Dockerfile
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install dependencies
RUN npm install

# Expose dev server port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev"]
