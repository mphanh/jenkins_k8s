FROM centos/httpd

ADD https://www.free-css.com/assets/files/free-css-templates/download/page254/photogenic.zip /var/www/html/
WORKDIR /var/www/html/
RUN yum install -y unzip && unzip photogenic.zip && rm photogenic.zip

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]