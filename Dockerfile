FROM nginx:latest

COPY html/index.txt /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]