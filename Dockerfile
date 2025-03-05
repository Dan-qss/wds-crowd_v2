# Use Python as base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Expose ports for the APIs and web server
EXPOSE 8010 8020 80

# Set environment variables if needed
ENV PYTHONUNBUFFERED=1

# Create a script to run all services
RUN echo '#!/bin/bash\n\
python Back/camera_system/camera_server.py &\n\
python Back/client/optimized_client.py &\n\
cd Back/database/crowd_management_database && uvicorn crowd-management-api:app --host 0.0.0.0 --port 8010 &\n\
cd Back/database/crowd_management_database && uvicorn face_recognition-api:app --host 0.0.0.0 --port 8020 &\n\
# Serve the front-end files\n\
python -m http.server 80 --directory Front/html\n\
wait\n' > /app/start_services.sh

RUN chmod +x /app/start_services.sh

# Command to run when the container starts
CMD ["/app/start_services.sh"]