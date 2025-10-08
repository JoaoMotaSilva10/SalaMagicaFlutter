# 🔄 Atualizações do Flutter - Sala Mágica

## 📋 Resumo das Mudanças

### 🔧 **Configurações Atualizadas**

#### 1. **ApiService** (`lib/api/api_service.dart`)
- ✅ URL alterada de ngrok para `http://localhost:8080`
- ✅ Removido header `ngrok-skip-browser-warning`
- ✅ Endpoint de login alterado para `/auth/login` (unificado)

#### 2. **Modelo Usuario** (`lib/model/usuario.dart`)
- ✅ Removido campo `unidade` (não usado para alunos)
- ✅ Mantidos campos: `rm`, `cpf`, `turma`, `serie`, `periodo`

#### 3. **Modelo Reserva** (`lib/model/reserva.dart`)
- ✅ Adicionado tratamento para datas em formato array `[ano, mês, dia, hora, minuto, segundo]`
- ✅ Fallback para datas em formato ISO string
- ✅ Validação de dados nulos

### 🆕 **Novos Serviços**

#### 1. **AuthService** (`lib/services/auth_service_new.dart`)
- ✅ Login unificado compatível com backend Spring Boot
- ✅ Gerenciamento automático de token JWT
- ✅ Persistência de dados do usuário com SharedPreferences
- ✅ Métodos para recuperação de senha
- ✅ Suporte a diferentes tipos de usuário (Aluno, Gerenciador, Administrador)

#### 2. **ReservaService** (`lib/services/reserva_service.dart`)
- ✅ CRUD completo de reservas
- ✅ Busca de recursos por tipo (AMBIENTE/EQUIPAMENTO)
- ✅ Verificação de disponibilidade
- ✅ Integração com autenticação JWT

### 🖥️ **Telas Atualizadas**

#### 1. **LoginScreen** (`lib/screens/login_screen.dart`)
- ✅ Integração com novo AuthService
- ✅ Gerenciamento automático de sessão
- ✅ Tratamento de erros melhorado

#### 2. **NovaReservaScreen** (`lib/screens/nova_reserva_screen.dart`)
- ✅ Tela moderna para criar reservas
- ✅ Seleção de recursos por tipo
- ✅ Seletor de data e hora
- ✅ Validação de disponibilidade
- ✅ Interface responsiva

#### 3. **MinhasReservasNovaScreen** (`lib/screens/minhas_reservas_nova_screen.dart`)
- ✅ Visualização de reservas do usuário
- ✅ Filtros por status
- ✅ Ações de cancelamento
- ✅ Atualização em tempo real
- ✅ Pull-to-refresh

### 🔗 **Rotas Atualizadas** (`lib/routes.dart`)
- ✅ Adicionadas rotas para novas telas
- ✅ Suporte a parâmetros tipados

## 🚀 **Como Usar**

### 1. **Executar o Backend**
```bash
cd SalaMagicaSpring
mvn spring-boot:run
```

### 2. **Executar o Flutter**
```bash
cd SalaMagicaFlutter
flutter pub get
flutter run
```

### 3. **Credenciais de Teste**
- **Email**: `joaopedromotasilva200@gmail.com`
- **Senha**: `12345678`

## 🔄 **Fluxo de Uso**

### **Para Alunos e Gerenciadores:**

1. **Login** → Tela de login unificada
2. **Dashboard** → Tela inicial com opções
3. **Nova Reserva** → Escolher tipo (Sala/Equipamento)
4. **Minhas Reservas** → Visualizar e gerenciar reservas
5. **Perfil** → Editar dados pessoais

### **Funcionalidades Principais:**

- ✅ **Autenticação JWT** com persistência
- ✅ **Reservas em tempo real** com validação
- ✅ **Interface moderna** e responsiva
- ✅ **Tratamento de erros** robusto
- ✅ **Sincronização** com backend Spring Boot

## 🔧 **Endpoints Utilizados**

### **Autenticação**
- `POST /auth/login` - Login unificado
- `GET /auth/validate` - Validar token

### **Reservas**
- `GET /reservas` - Listar todas as reservas
- `GET /reservas/pessoa/{id}` - Reservas por usuário
- `POST /reservas` - Criar nova reserva
- `PUT /reservas/{id}` - Atualizar reserva
- `DELETE /reservas/{id}` - Cancelar reserva
- `PUT /reservas/{id}/confirmar` - Confirmar realização

### **Recursos**
- `GET /recursos` - Listar recursos
- `GET /recursos?tipo=AMBIENTE` - Listar salas
- `GET /recursos?tipo=EQUIPAMENTO` - Listar equipamentos

### **Usuários**
- `GET /alunos` - Listar alunos
- `GET /gerenciadores` - Listar gerenciadores
- `PUT /alunos/{id}` - Atualizar perfil de aluno
- `PUT /gerenciadores/{id}` - Atualizar perfil de gerenciador

## 📱 **Compatibilidade**

- ✅ **Android** - Testado e funcionando
- ✅ **iOS** - Compatível (não testado)
- ✅ **Web** - Compatível com CORS configurado
- ✅ **Desktop** - Windows/Linux/macOS

## 🔒 **Segurança**

- ✅ **JWT Tokens** para autenticação
- ✅ **Headers de autorização** automáticos
- ✅ **Validação de sessão** em tempo real
- ✅ **Logout seguro** com limpeza de dados

## 🎯 **Próximos Passos**

1. **Testes** em dispositivos físicos
2. **Notificações push** para status de reservas
3. **Modo offline** com sincronização
4. **Temas personalizáveis**
5. **Relatórios** de uso