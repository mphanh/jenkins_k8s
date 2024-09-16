FROM centos/httpd

ADD https://www.tooplate.com/download/2137_barista_cafe /var/www/html/
WORKDIR /var/www/html/
RUN yum install -y unzip && unzip 2137_barista_cafe.zip && rm 2137_barista_cafe.zip

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]