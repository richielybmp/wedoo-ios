# WeDoo - iOS Version
Repositório destinado ao projeto final da disciplina de Desenvolvimento para iOS - Especialização Full Stack - UFG

O WeDoo têm o propósito de ajudar a organizar as tarefas e listas de deveres do dia-a-dia.
Crie seções de listas como: listas de estudos, lista de compras, atividades diárias, programações de itens a serem seguidos. Nós chamamos esses organizadores de "ToDoos".

Cada ToDoo pode ser composto por vários itens (ToDooItem). Você poderá associar a descrição desse item, adicionar uma imagem/fotografia e marcar o item como concluído/finalizado com uma ação de swipe na célula da tabela.

Assim, as pessoas podem se organizar no dia-a-dia, por exemplo, criando uma lista de assuntos para estudar ou até mesmo uma lista de compras de carnes, bebidas e derivados para aquele churrasco do final de samana com a galera.

Para autenticação, utilizamos a plataforma do Firebase. 

Para armazenamento dos dados, usamos o próprio CoreData, trabalhando com a manipulação dos dados de forma local com o Managed Object Context. Sabemos que isso é um ponto negativo pois caso o aplicativo for desinstalado do dispositivo, os dados serão perdidos. Para sanar esse problema, podemos migrar para o armazenamento em nuvem e utilizar o Firebase Database, vinculando os dados com o usuário autenticado.

### O que usamos?

- [Firebase Authentication](https://firebase.google.com/docs/auth/?hl=pt-br).
- [Google Sign In](https://firebase.google.com/docs/auth/ios/google-signin?hl=pt-br).
- [AlamofireImage](https://github.com/Alamofire/Alamofire)
- [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar)

## Autores

* **[Filipe Maciel](https://github.com/devfilsk)**.
* **[Mateus Stedler](https://github.com/mstedler)**.
* **[Richiely Paiva](https://github.com/richielybmp)**.

Veja também a lista dos [contribuidores](https://github.com/richielybmp/fea-eCommerce/graphs/contributors) que participaram desse projeto.

## Issues log, implementações futuras e pendentes
 - Migrar a forma de armazenamento atual (stores data only on device) para Firebase Database(cloud database);
 - Notificar ToDooItem não concluído próximo ao prazo de expirar;
 - Permitir usuário criado via email e senha modificar sua foto de perfil da conta;
 - Agregar ToDoos para um grupo de usuários específicos;
 - Compartilhar ToDoos.
 - ~~About Activity.~~
 
