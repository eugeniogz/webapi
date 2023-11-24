# memo_webapi

Projeto baseado no primeiro curso de WebAPI da Formação Flutter da alura,
possui um caso completo de acesso a uma API rest usando json-server
passos para iniciar o servidor:

> cd server
>
> npm start

para versão com login inicie o servidor com

> cd server
>
> npm run start-auth

O usuário default é j@ufmg.br, senha 12345aB

# Antes de executar o projeto
edite em globals.dart a string url para ficar de acordo com o IP de sua máquina local (consulte seu ip com ifconfig (Mac e Linux) ou ipconfig (Windows))

## Pré-requisitos para gerar app linux
sudo apt-get install libsecret-1-dev libjsoncpp-dev libsecret-1-0

## Dicas
Se tiver algum problema com os projetos gerados, e.g. ios, apague a pasta correspondente e digite "flutter create ." no terminal