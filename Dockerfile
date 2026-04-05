# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Install system dependencies for dlib, face-recognition, and OpenCV-related packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libx11-6 \
    libxext6 \
    libxrender-dev \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Run the application with gunicorn
# Railway automatically sets the PORT environment variable
CMD gunicorn --bind 0.0.0.0:$PORT app:app
