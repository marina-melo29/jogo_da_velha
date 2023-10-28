## Instalando Ruby no Ubuntu:

No terminal, digite:

1 - instalação 

> sudo apt install ruby-2.7.1

2 - verifique se deu certo:

> ruby --version


## Instalando Ruby no Windows 10:

Para instalar o Ruby no Windows 10, você pode usar uma distribuição do Windows chamada "RubyInstaller":

1 - Baixe o RubyInstaller: Vá para o site oficial do RubyInstaller para Windows (https://rubyinstaller.org/) e baixe a versão mais recente do RubyInstaller. Certifique-se de baixar a versão recomendada (não a versão "DevKit" a menos que você tenha necessidades específicas).

2 - Execute o instalador: Execute o arquivo baixado e siga as instruções do instalador.

3 - Verifique a instalação: Após a instalação, abra o Prompt de Comando do Windows e execute:

> ruby --version

## Preparativos do jogo

1 - Para realizar a instalação das gems (bibliotecas) que contribuem pro funcionamento do jogo, rode o seguinte comando em seu terminal dentro da pasta do projeto:

> gem install bundler

e depois:

> bundle install

## Inicializando o jogo

1 - Agora, vamos entrar no terminal do ruby digitando

> irb

2 - Agora, dentro do terminal, precisamos carregar o arquivo do jogo com o comando "load 'game_intro.rb'":

> irb(main):001:0> load 'game_intro.rb'

3 - Agora, basta inicializa-lo com o comando "GameIntro.new":

> irb(main):001:0> GameIntro.new
