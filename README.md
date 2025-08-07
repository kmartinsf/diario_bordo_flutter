# 🌍 Diario de Bordo

Aplicativo de diário de viagens, onde usuários podem registrar, editar e visualizar suas viagens com informações como localização, resumo, avaliação e foto de capa. Desenvolvido em Flutter 3 utilizando Firebase e integração com a API GeoDB para sugestões de cidades.

---

## ✨ Demonstração

> **GIF da aplicação em funcionamento (APK em execução):**
> 
![Demonstração da aplicação](https://i.postimg.cc/kDYg12b5/demo.gif)
---

### 📦 Baixar o APK

➡️ **[Clique aqui para baixar o APK](https://github.com/kmartinsf/diario_bordo_flutter/releases/tag/apk)**  
*(Necessário permitir instalações de fontes desconhecidas no seu dispositivo)*

---

## 📚 Funcionalidades

- [x] Autenticação de usuário (registro, login, logout)
- [x] Cadastro de diário de viagem (com upload de imagem)
- [x] Sugestão automática de localização via API externa (GeoDB)
- [x] Lista de diários do usuário
- [x] Modal de detalhes do diário
- [x] Edição e exclusão de diário
- [x] Edição de perfil (nome, cidade e foto)
- [x] Feedback visual com loaders e mensagens de erro

---

## 🛠️ Tecnologias e Bibliotecas

| Categoria                | Tecnologias                         |
|-------------------------|--------------------------------------|
| Framework               | Flutter 3                            |
| Estado                  | Riverpod                             |
| Autenticação            | Firebase Auth                        |
| Banco de dados          | Firebase Firestore                   |
| Armazenamento de imagem| Firebase Storage                     |
| Requisições HTTP        | Dio                                  |
| Sugestão de cidades     | GeoDB Cities API (via RapidAPI)     |
| Gerenciamento de imagem| ImagePicker, compressImage util     |

---

## 📁 Estrutura de Pastas

```
lib/
├── constants/              # Cores e constantes visuais
├── data/
│   ├── models/            # Modelos (UserModel, TravelJournal)
│   ├── repositories/      # Firestore + Storage abstrações
│   └── services/          # Serviços HTTP e FirebaseAuth
├── presentation/
│   ├── screens/           # Telas principais (home, login, perfil...)
│   └── widgets/           # Componentes reutilizáveis e modais
├── providers/             # Providers do Riverpod
├── utils/                 # Funções auxiliares (compressão, imagem...)
└── main.dart              # Ponto de entrada da aplicação
```

---

## 🧪 Setup do Projeto

### 1. Clone o repositório

```bash
git clone (https://github.com/kmartinsf/diario_bordo_flutter.git)
cd diario-bordo-flutter
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure as variáveis de ambiente

Este projeto utiliza uma API pública para o autocomplete de localização.  
Para isso, é necessário obter uma chave gratuita em [RapidAPI GeoDB Cities](https://rapidapi.com/wirefreethought/api/geodb-cities).

![GeoDB Cities](https://i.postimg.cc/3wCPYPtX/Screenshot-2025-08-07-170046.png)
![X-RapidAPI-Key](https://i.postimg.cc/ZqhGkTxY/Screenshot-2025-08-07-170125.png)

Após criar sua conta e copiar a chave (X-RapidAPI-Key), crie um arquivo `.env` na raiz do projeto com:

```env
GEODB_API_KEY=SUA_CHAVE_AQUI
```

### 4. Configure o Firebase

Este projeto utiliza Firebase Auth, Firestore e Storage. Para rodar localmente, você deve:

#### a) Criar um projeto no [Firebase Console](https://console.firebase.google.com/)

#### b) Ativar os serviços:

- Authentication (modo: Email/Senha)
- Cloud Firestore
- Cloud Storage

#### c) Regras temporárias de desenvolvimento:

<details>
<summary><strong>Storage</strong></summary>

```js
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```
</details>

#### d) Instalar a CLI do FlutterFire

```bash
dart pub global activate flutterfire_cli
```

#### e) Rodar o comando abaixo para gerar o arquivo `firebase_options.dart`

```bash
flutterfire configure
```

> Mesmo que o arquivo `firebase_options.dart` exista no repositório, ele é específico do projeto original. Para funcionar no seu ambiente, é necessário gerar um novo.

---

## 📊 Estrutura de dados

### Usuário (`users` - Firestore)

```json
{
  "name": "Kai",
  "email": "kai@email.com",
  "city": "Florianópolis",
  "photoUrl": "https://...",
  "createdAt": Timestamp
}

```

### Diário (`users/{userId}/journals` - Subcoleção)

```json
{
  "title": "Viagem para Londres",
  "location": "London",
  "description": "Visitei a Tower Bridge",
  "rating": 4.5,
  "coverUrl": "https://...",
  "createdAt": Timestamp
}
```

---

> **Nota**: A tela de detalhes do diário originalmente incluía um mapa com a localização, não consegui desenvolver essa feature.

---

## 🚀 Autora

Desenvolvido por Kaiena Martins

---
