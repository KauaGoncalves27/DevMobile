# Estrutura do projeto

## Arquivos

| Arquivo                   | Conteúdo                                                        |
|---------------------------|-----------------------------------------------------------------|
| `lib/main.dart`           | `AppCadastro`: cria o `MaterialApp` e o tema preto e branco (campos, botão) |
| `lib/tela_cadastro.dart`  | `TelaCadastro`: a tela com o formulário                         |
| `lib/validadores.dart`    | `Validadores`: uma função de validação para cada campo          |
| `test/widget_test.dart`   | Testes da tela e das validações                                 |

Separar as validações em `validadores.dart` deixa a tela mais curta e permite
testar as regras sem abrir a tela.

## Hierarquia de widgets

Segue a estrutura pedida no enunciado:

```
Scaffold
├── AppBar ("Cadastro de usuário")
└── Form(key: _formKey)
    └── SingleChildScrollView (padding = margens laterais)
        └── Column
            ├── _Cabecalho (ícone, título e subtítulo)
            ├── TextFormField (nome)
            ├── SizedBox(height: 16)
            ├── TextFormField (e-mail)
            ├── SizedBox(height: 16)
            ├── TextFormField (CPF)
            ├── SizedBox(height: 16)
            ├── TextFormField (telefone)
            ├── SizedBox(height: 16)
            ├── TextFormField (senha)            ← desafio: olho
            ├── SizedBox(height: 16)
            ├── TextFormField (confirmar senha)  ← desafio
            ├── ElevatedButton (CADASTRAR)
            └── TextButton (Limpar campos)
```

- `SingleChildScrollView` evita overflow quando o teclado abre.
- O `padding` do `SingleChildScrollView` dá 20px de margem no celular. Em tela larga
  (navegador) ele aumenta para deixar o formulário centralizado com no máximo 460px.

## Teclado e filtros de cada campo

| Campo           | `keyboardType` | Filtro (`inputFormatters` / `maxLength`)         |
|-----------------|----------------|--------------------------------------------------|
| Nome completo   | `name`         | só letras, espaço e apóstrofo                    |
| E-mail          | `emailAddress` | bloqueia espaços                                 |
| CPF             | `number`       | `digitsOnly` + `maxLength: 11` (mostra contador) |
| Telefone        | `phone`        | `digitsOnly` + `maxLength: 11` (mostra contador) |
| Senha           | padrão         | `obscureText` + botão de olho                    |
| Confirmar senha | padrão         | `obscureText` + botão de olho                    |

## Regras de validação (`Validadores`)

Todos os campos são obrigatórios.

| Campo           | Regra                                   | Mensagem                                         |
|-----------------|-----------------------------------------|--------------------------------------------------|
| Nome            | vazio                                   | Informe o seu nome completo.                     |
|                 | sem sobrenome                           | Informe nome e sobrenome.                        |
| E-mail          | vazio                                   | Informe o seu e-mail.                            |
|                 | sem `@`                                 | O e-mail precisa ter o caractere @.              |
|                 | fora do formato (RegExp)                | Formato inválido. Exemplo: nome@dominio.com      |
| CPF             | vazio                                   | Informe o seu CPF.                               |
|                 | menos de 11 dígitos                     | CPF incompleto: falta(m) N dígito(s).            |
| Telefone        | vazio                                   | Informe o seu telefone.                          |
|                 | diferente de 10 ou 11 dígitos           | Digite DDD + número (10 ou 11 dígitos).          |
| Senha           | vazia                                   | Crie uma senha.                                  |
|                 | menos de 6 caracteres                   | A senha precisa ter pelo menos 6 caracteres.     |
| Confirmar senha | vazia                                   | Repita a senha para confirmar.                   |
|                 | diferente da senha                      | As senhas digitadas são diferentes.              |

RegExp do e-mail: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

## O que acontece ao tocar em CADASTRAR (`_cadastrar`)

1. Fecha o teclado.
2. `_formKey.currentState!.validate()` roda o `validator` de cada campo.
3. **Tudo válido:** `SnackBar` verde com o primeiro nome digitado.
4. **Algum erro:** cada mensagem aparece embaixo do seu campo, o `SnackBar` vermelho
   diz quantos campos faltam corrigir, e o formulário passa para
   `AutovalidateMode.onUserInteraction` (os erros somem assim que o campo é corrigido).

## Desafios

| Desafio                              | Onde                                         |
|--------------------------------------|----------------------------------------------|
| Confirmação de senha                 | `Validadores.confirmacao`                    |
| Mostrar/ocultar senha                | `_BotaoOlho` no `suffixIcon`                 |
| E-mail com RegExp                    | `Validadores.email`                          |
| SnackBar de erro vermelho            | `_mostrarAviso(..., sucesso: false)`         |
