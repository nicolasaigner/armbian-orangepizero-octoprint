#!/bin/bash

# Clone o repositório armbian/build
git clone https://github.com/armbian/build

# Crie o diretório build/userpatches
mkdir -p build/userpatches

# Copie suas configurações customizadas para build/userpatches
cp customize-image.sh build/userpatches

# Entre no diretório do projeto armbian/build
cd build

# Execute o script compile.sh com as configurações desejadas
./compile.sh BOARD=orangepizero BRANCH=current BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=no RELEASE=focal SHARE_LOG=yes | tee build.log

# Quando o build estiver completo, encontre a URL do log e abra no navegador default
url=$(grep -o 'https://paste.next.armbian.com/.*' build.log)
if [ -n "$url" ]; then
    xdg-open "$url"
fi
