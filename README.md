# 📱 Sala Mágica - Mobile App

> Sistema mobile para reserva de salas e equipamentos escolares desenvolvido em Flutter

## 🚀 Sobre o Projeto

O **Sala Mágica** é um aplicativo mobile que facilita a reserva de salas e equipamentos em instituições de ensino. Com uma interface moderna e intuitiva, permite que alunos e funcionários façam reservas de forma rápida e eficiente.

## ✨ Funcionalidades

### 🔐 **Autenticação**
- Login seguro com validação
- Cadastro de novos usuários
- **Recuperação de senha** via e-mail com código de 6 dígitos
- Manter sessão ativa

### 📋 **Reservas**
- Reserva de salas de aula
- Reserva de equipamentos (projetores, notebooks, etc.)
- Visualização de reservas ativas
- Histórico de reservas realizadas

### 👤 **Perfil do Usuário**
- Visualização de dados pessoais
- Informações acadêmicas (RM, turma, série)
- Logout seguro

### 🎨 **Interface**
- Design moderno com gradientes
- Tema escuro elegante
- Animações suaves
- Responsivo para diferentes tamanhos de tela

### 📊 **Análise (Admin)**
- Dashboard com estatísticas de uso
- Relatórios de reservas
- Gerenciamento de recursos

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.7.2+ - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **HTTP** - Comunicação com API REST
- **Provider** - Gerenciamento de estado
- **Material Design** - Design system

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  http: ^1.4.0
  intl: ^0.20.2
  flutter_svg: ^2.2.0
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.7.2+
- Dart SDK
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/JoaoMotaSilva10/SalaMagicaFlutter.git
cd SalaMagicaFlutter
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o backend**
   - Certifique-se que o backend Spring Boot está rodando em `http://localhost:8080`
   - Verifique a configuração em `lib/api/api_service.dart`

4. **Execute o aplicativo**
```bash
flutter run
```

## 🏗️ Estrutura do Projeto

```
lib/
├── api/                    # Serviços de API
│   └── api_service.dart   # Comunicação com backend
├── model/                 # Modelos de dados
│   ├── usuario.dart
│   ├── reserva.dart
│   └── recurso.dart
├── screens/               # Telas do aplicativo
│   ├── login_screen.dart
│   ├── cadastro_screen.dart
│   ├── esqueci_senha_screen.dart
│   ├── reset_senha_screen.dart
│   ├── inicio_screen.dart
│   ├── perfil_screen.dart
│   └── ...
├── widgets/               # Componentes reutilizáveis
│   ├── gradient_background.dart
│   └── modern_button.dart
├── routes.dart           # Configuração de rotas
└── main.dart            # Ponto de entrada
```

## 🔧 Configuração da API

O app se comunica com o backend através da classe `ApiService`. Para alterar a URL base:

```dart
// lib/api/api_service.dart
static const String baseUrl = 'http://localhost:8080';
```

## 🎨 Personalização

### Cores do Tema
```dart
// Cores principais
primary: Color(0xFF6200ea)     // Roxo principal
secondary: Color(0xFF7e3ff2)   // Roxo secundário
background: Color(0xFF0a0a0a)  // Fundo escuro
```

### Fonte
- **Poppins** - Fonte principal do aplicativo

## 📱 Telas Principais

1. **Login** - Autenticação do usuário
2. **Cadastro** - Registro de novos usuários
3. **Esqueci Senha** - Recuperação via e-mail
4. **Início** - Dashboard principal
5. **Reservas** - Listagem e criação de reservas
6. **Perfil** - Dados do usuário

## 🔐 Segurança

- Validação de entrada em todos os formulários
- Comunicação segura com API via HTTPS (produção)
- Tokens de recuperação de senha com expiração
- Logout seguro com limpeza de sessão

## 🚀 Deploy

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 👥 Equipe

- **João Pedro Mota Silva** - Desenvolvedor Principal
- **Gabriel Barbosa** - Colaborador

## 📞 Contato

- Email: joaomotasilva10@outlook.com
- GitHub: (https://github.com/JoaoMotaSilva10)

---

⭐ **Se este projeto te ajudou, deixe uma estrela!**