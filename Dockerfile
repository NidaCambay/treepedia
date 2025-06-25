FROM nginx:alpine

# index.html ve görseli container içine kopyala
COPY index.html /usr/share/nginx/html/index.html
COPY zeytin.jpg /usr/share/nginx/html/zeytin.jpg
COPY cam.jpg /usr/share/nginx/html/cam.jpg
COPY mese.jpg /usr/share/nginx/html/mese.jpg