# Pull alpine linux image
FROM centos:8.3.2011

# Update the environment and perform yum installations
RUN yum update -y \
    && yum install -y python3 \
    && yum install -y mysql-devel gcc python3-devel \
    && yum clean all

# Set the working directory to swim-wb-py
WORKDIR /swim-wb-py

# Copy project directory into the container at swim-wb-py
COPY  . /swim-wb-py

# Update pip and setup virtual python environment
RUN python3 -m pip --no-cache-dir install --user --upgrade pip \
    && python3 -m pip --no-cache-dir install --user virtualenv \
    && python3 -m venv env \
    && source env/bin/activate

# Install the dependencies
RUN python3 -m pip --no-cache-dir install -r requirements.txt

# Expose port
EXPOSE 5000

# Production WSGI Server
CMD ["uwsgi", "app.ini"]