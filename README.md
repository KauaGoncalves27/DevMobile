# Cadastro de Usuário — Flutter

Atividade de **Desenvolvimento Mobile**: tela de cadastro com `Form` e `TextFormField`,
filtros de digitação, validação campo a campo e aviso com `SnackBar`.

Autor: Kauã Gonçalves

## O que a tela faz

- Campos: nome completo, e-mail, CPF, telefone, senha e confirmação de senha.
- Cada campo tem o teclado certo (`keyboardType`) e filtros de entrada (`inputFormatters`):
  CPF e telefone só aceitam números (até 11), o nome não aceita números e o e-mail não aceita espaços.
- Ao tocar em **CADASTRAR**, os erros aparecem logo abaixo de cada campo inválido.
  Depois da primeira tentativa, as mensagens se atualizam enquanto o usuário corrige.
- Tudo certo: aviso verde "Cadastro concluído! Bem-vindo(a), _primeiro nome_."
- Algo errado: aviso vermelho dizendo quantos campos precisam ser corrigidos.
- Botão **Limpar campos** apaga o formulário.
- Visual em preto e branco; só os avisos têm cor (verde para sucesso, vermelho para erro).

Desafios feitos: confirmação de senha, botão de mostrar/esconder senha (olho),
e-mail validado com `RegExp` e `SnackBar` de erro em vermelho.

A organização do código está em [ESTRUTURA.md](ESTRUTURA.md).

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

Sem o Chrome, use `flutter run -d web-server` e abra o endereço que aparecer no terminal.

## Testes

```bash
flutter test
```
