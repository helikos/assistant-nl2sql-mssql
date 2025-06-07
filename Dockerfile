# Use the official Python image as a base image
FROM python:3.12-slim

RUN apt update && apt install -y build-essential 
RUN apt-get update && apt-get install -y libasound-dev portaudio19-dev

RUN apt-get update
RUN apt-get install -y curl apt-transport-https locales gnupg2
RUN apt-get install apt-transport-https 
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN exit
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
#RUN apt install -y python3-pyaudio

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc 

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

RUN pip install --upgrade pip
# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the src directory and app.py into the container
COPY src/ src/
COPY app.py .
COPY .env .


# Expose the port that Streamlit will run on
EXPOSE 8501

# Command to run the Streamlit app
CMD ["streamlit", "run", "app.py"]