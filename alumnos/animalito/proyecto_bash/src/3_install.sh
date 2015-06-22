#!/bin/bash

echo

SOURCE="${BASH_SOURCE[0]}"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo Ejecutando $SOURCE
echo Carpeta de ejecución $DIR

echo Instala R y paquetes necesarios

parallel --nonall --slf $DIR/../data/instancias.txt 'sudo apt-get update; sudo apt-get install -y r-base-core'

parallel --nonall --slf $DIR/../data/instancias.txt "sudo apt-get -y install curl libxml2 libxml2-dev libcurl4-openssl-dev"

parallel --nonall --basefile instala_paquetes.r --slf $DIR/../data/instancias.txt 'sudo Rscript ./instala_paquetes.r'
