# Armbian OctoPrint Build para Orange Pi Zero

Este repositório contém uma customização específica para construir uma imagem Armbian para rodar o OctoPrint no Orange Pi Zero.

## Como usar

Este projeto utilizar o build do Armbian onde você pode encontrar mais informações [aqui](https://github.com/armbian/build). Para usar, você precisa clonar este repositório e executar o script bash fornecido. O script faz o seguinte:

1. Clone o repositório `git clone https://github.com/nicolasaigner/armbian-orangepizero-octoprint.git`;
2. Acesse a pasta `cd armbian-orangepizero-octoprint`;
3. Baixe o repositório do armbian build `git clone https://github.com/armbian/build.git`;
4. Copie o script do `userpatches/customize-image.sh` para a pasta do `build`: `cp -r userpatches build/`;
5. Verique se o arquivo do `customize-image.sh` é executável: `ls -lah build/userpatches/`:

```bash
-rw-rw-r--  1 nicolas nicolas 2,0K mai  9 20:09 customize-image.sh
```

6. Se o seu arquivo estiver como o meu resultado acima `-rw-rw-r--` ele não é executável. Com isso execute o comando: `chmod +x build/userpatches/customize-image.sh && ls -lah build/userpatches/`:

```bash
-rwxrwxr-x  1 nicolas nicolas 2,0K mai  9 20:09 customize-image.sh
``` 

Agora sim, quando estiver dessa forma: `-rwxrwxr-x`, ele é executável;

7. Verifique também se o `build/compile.sh` também é executável, se não for: `chmod +x build/compile.sh`;
8. Execute o script `build/compile.sh` com essas configurações: 

```bash
./build/compile.sh \
BOARD=orangepizero \
BRANCH=current \
BUILD_DESKTOP=no \
BUILD_MINIMAL=yes \
KERNEL_CONFIGURE=no \
RELEASE=focal \
DEST_LANG="pt_BR.UTF-8" \
SHARE_LOG=yes
```

9. Aguarde os logs, no fim você terá um link para acessar no terminal parecido com esse: 
```bash

```

