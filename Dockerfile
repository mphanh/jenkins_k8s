# Use the centos/httpd image
FROM centos/httpd

# Install wget to download the website template
RUN yum -y install wget unzip

# Set the working directory to /var/www/html (default Apache root)
WORKDIR /var/www/html

# Download the template from Tooplate and unzip it
RUN wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip && \
    unzip 2137_barista_cafe.zip && \
    mv 2137_barista_cafe/* . && \
    rm -rf 2137_barista_cafe 2137_barista_cafe.zip

# Expose port 80 (HTTP)
EXPOSE 80

# Start Apache HTTP server in the foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
