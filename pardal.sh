#!/bin/bash

if [ $# -eq 0 ]; then
echo "Uso: $0 <URL>"
exit 1
fi

extract_title() {
curl -s "$1" | grep -o "<title>[^<]*" | sed -e 's/<title>//'
}

extract_server() {
curl -sI "$1" | grep -i "^Server:" | awk '{print $2}'
}

extract_language() {
curl -s "$1" | grep -i -o "x-powered-by:.*" | cut -d ":" -f2
}

extract_urls() {
curl -s "$1" | grep -o 'href="[^"]*"' | cut -d'"' -f2
}

extract_forms() {
curl -s "$1" | grep -Eo '<form[^>]*>' | grep -o 'action="[^"]*"' | cut -d'"' -f2
curl -s "$1" | grep -Eo '<input[^>]*>'
}

URL="$1"

echo "título: $(extract_title $URL)"
echo "servidor: $(extract_server $URL)"
echo "linguagem: $(extract_language $URL)"

echo "todas as urls:"
extract_urls $URL

echo "formularios:"
extract_forms $URL
