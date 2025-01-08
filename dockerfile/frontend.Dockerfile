# Step 1: Use a Node.js image to install dependencies and run the application
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the package files first to install dependencies
COPY frontend/package.json frontend/package-lock.json ./

# Install dependencies (this will use the package.json and package-lock.json from your local machine)
RUN npm install

# Step 2: Copy the rest of the frontend files into the container
COPY ./frontend ./

# Expose the default Angular development server port (4200)
EXPOSE 4200

# Step 3: Run npm start to serve the application
CMD ["npm", "start", "--", "--host", "0.0.0.0"]