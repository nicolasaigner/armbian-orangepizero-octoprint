# Armbian OctoPrint Build para Orange Pi Zero

Este repositório contém uma customização específica para construir uma imagem Armbian para rodar o OctoPrint no Orange Pi Zero.

## Como usar

Este projeto utilizar o build do Armbian onde você pode encontrar mais informações [aqui](https://github.com/armbian/build). Para usar, você precisa clonar este repositório e executar o script bash fornecido. O script faz o seguinte:

1. Clona o repositório `armbian/build`.
2. Cria o diretório `build/userpatches`.
3. Copia o arquivo de configuração customizado `armbian/customize-image.sh` para `build/userpatches`;
4. Executa o script `compile.sh` com as configurações especificadas;
5. Salva todos os logs de build em `build.log`;
6. Quando o build estiver completo, procura a URL do log no `build.log` e abre no navegador padrão os logs gerados;
7. A imagem gerada ficara em `armbian-orangepizero-octoprint/build/output`.
