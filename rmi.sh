#!/bin/bash

archivo="docker.txt"
if [ -e "$archivo" ]; then
  while IFS= read -r linea; do
    docker rmi $linea
  done < "$archivo"
else
  echo "El archivo no existe."
fi
