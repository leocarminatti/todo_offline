# Meu App Flutter 🚀

## 📌 Descrição
Este é um aplicativo Flutter estruturado com a arquitetura MVVM, utilizando **Cubit** para gerenciamento de estado, **GoRouter** para navegação, **Hive** para armazenamento offline e **Mocktail** para testes automatizados.

## 🛠️ Arquitetura Utilizada
O projeto segue a estrutura MVVM conforme a documentação oficial do Flutter:

```
lib
|____ui
| |____core
| | |____widgets
| | | |____<shared widgets>
| |____<FEATURE NAME>
| | |____view_model
| | | |_____<view_model class>.dart
| | |____view
| | | |____<feature name>_screen.dart
|____domain
| |____entities
| | |____<entity name>.dart
|____usecases
| | |____<use case name>.dart
|____data
| |____repositories
| | |____<repository class>.dart
| |____services
| | |____<service class>.dart
| |____model
| | |____<api model class>.dart
|____config
|____routes
|____main.dart

test
|____data
|____domain
|____ui
|____fakes
|____models

```

## 🚀 Como rodar o projeto?

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/leocarminatti/todo_offline.git
   cd todo_offline
   ```

2. **Instale as dependências:**
   ```sh
   flutter pub get
   ```

3. **Execute o aplicativo:**
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Execute o aplicativo:**
   ```sh
   flutter run
   ```

## 📦 Tecnologias e Dependências
O projeto utiliza as seguintes bibliotecas externas:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  go_router: ^10.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get_it: ^8.0.3
  fpdart: ^1.1.1
  uuid: ^4.5.1

dev_dependencies:
  bloc_test: ^9.1.2
  mocktail: ^1.0.3
  build_runner: ^2.3.3
  hive_generator: ^2.0.1
  path_provider_platform_interface: ^2.0.5
  flutter_test:
    sdk: flutter
```

## 🏗️ Estrutura do Código
O código está dividido em **camadas** seguindo o MVVM:
- **UI:** Contém as telas e widgets reutilizáveis.
- **ViewModel:** Gerencia o estado da UI usando Cubit.
- **Domain:** Contém modelos que representam os dados da aplicação.
- **Data:** Camada responsável pelo acesso a repositórios, serviços e comunicação com API/local storage.
- **Routing:** Configuração da navegação com GoRouter.

## 🧪 Testes Automatizados
O projeto utiliza **Mocktail** para testes unitários e **bloc_test** para testar a lógica de estado.

📌 **Executar todos os testes:**
```sh
flutter test
```

## 📜 Licença
Este projeto está sob a licença MIT.

