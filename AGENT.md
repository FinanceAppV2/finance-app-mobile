# AGENT.md — Finance App Mobile

## Missão antes de criar qualquer Feature

Antes de iniciar o desenvolvimento de uma nova feature, siga **rigorosamente** os passos abaixo:

### 1. Analisar o projeto existente

- Leia este documento inteiro.
- Leia `skills/layout/project-strucutre.md` para entender a arquitetura.
- Leia `lib/features/auth/` (implementação de referência) para entender o padrão usado em **todas as camadas**.
- Confira o arquivo de rota em `lib/routes/app_routes.dart` e `app_pages.dart`.
- Confira o arquivo de DI em `lib/di/injector.dart` para ver como as dependências são registradas.
- Confira `lib/core/network/dio_client.dart` para ver como o client HTTP é configurado.
- Confira `lib/core/theme/app_theme.dart` para usar `AppColors.*` e o tema escuro.

### 2. Seguir a Estrutura de Diretórios (Clean Architecture)

Toda feature nova deve seguir exatamente este padrão:

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/       # APIs, SharedPreferences, Hive
│   ├── models/            # DTOs com fromJson / toJson / toEntity
│   └── repositories/      # Implementação concreta do repositório
├── domain/
│   ├── entities/          # Classes puras Dart (sem dependências externas)
│   ├── repositories/      # Interfaces abstratas
│   └── usecases/          # Um caso de uso por classe
└── presentation/
    ├── controllers/       # ChangeNotifier
    ├── pages/             # Telas
    └── widgets/           # Widgets específicos da feature
```

### 3. Convenções de Código

| Categoria | Convenção | Exemplo |
|---|---|---|
| Arquivos | `snake_case` | `login_usecase.dart` |
| Classes | `PascalCase` | `LoginUseCase` |
| Métodos | `camelCase` | `execute()` |
| Campos privados | prefixo `_` | `_status`, `_errorMessage` |
| Constantes | `camelCase` | `static const baseUrl` |
| Enums | valores `lowercase` | `enum Status { initial, loading }` |
| Abstratas | `PascalCase` | `abstract class AuthRepository` |
| Implementações | `Classe + Impl` | `AuthRepositoryImpl` |
| Models | `Entity + Model` | `UserModel` |
| Use Cases | `Verbo + Substantivo + UseCase` | `LoginUseCase` |
| Controllers | `Feature + Controller` | `AuthController` |
| Data Sources | `Feature + Remote/Local + DataSource` | `AuthRemoteDataSource` |

### 4. Regras de Implementação

- **Controllers**: extends `ChangeNotifier`, injeta UseCase, usa enum de status + `_errorMessage`. Sempre chama `notifyListeners()` antes e depois da operação assíncrona. Usa `result.fold()` do `fpdart`.
- **Repositories (interface)**: retorna `Future<Either<String, Entity>>` do `fpdart`.
- **Repositories (impl)**: `try/catch` nas chamadas de data source, retorna `Right(model.toEntity())` ou `Left('Erro: $e')`.
- **Models**: extends `Equatable`, override `props`, tem `fromJson()`, `toJson()`, `toEntity()` manuais (sem `freezed`/`@JsonSerializable`).
- **Entities**: classes puras sem dependências de framework.
- **DI**: registra `registerLazySingleton` para DataSources, Repositories, UseCases; `registerFactory` para Controllers.
- **Rotas**: adiciona constante em `app_routes.dart` e rota em `app_pages.dart`.
- **Cores**: **NUNCA** hardcode. Use `AppColors.*` importando `core/theme/app_theme.dart`.
- **Apenas dark mode**: `ThemeData(brightness: Brightness.dark)`.
- **Import relativo** dentro de features e entre feature e core. Import com `package:` usado em `app_pages.dart` e libs externas.

---

## Documentação da API

Consulte a documentação atualizada da API via OpenAPI/Swagger sempre que for implementar uma nova feature:

**URL:** `https://dev-nsisj-api-dbcjfvh2ajeuerh2.eastus2-01.azurewebsites.net/v3/api-docs`

**Base URL:** `https://dev-nsisj-api-dbcjfvh2ajeuerh2.eastus2-01.azurewebsites.net`

**Segurança:** ApiKey + BearerAuth (JWT)

---

## Workflow para Nova Feature

1. Leia este `AGENT.md` completamente.
2. Leia `skills/layout/project-strucutre.md`.
3. Leia a feature de referência `lib/features/auth/` (todas as camadas).
4. **Faça uma requisição HTTP para a URL da OpenAPI acima** para obter os endpoints e schemas atualizados da API antes de implementar.
5. Crie a estrutura de diretórios seguindo o padrão Clean Architecture.
6. Implemente na ordem: **domain** (entities → repository interface → use cases) → **data** (datasource → models → repository impl) → **presentation** (controller → pages/widgets) → **DI** → **routes**.
7. Após criar, verifique se registrou todas as dependências no `injector.dart`.
8. Verifique se adicionou a rota em `app_routes.dart` e `app_pages.dart`.
9. Use `AppColors.*` para todas as cores — nunca hardcode.
