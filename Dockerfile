FROM nginx:alpine

COPY index.html /usr/share/nginx/html/
COPY zeytin.jpg /usr/share/nginx/html/
COPY cam.jpg /usr/share/nginx/html/
COPY mese.jpg /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]

