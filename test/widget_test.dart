import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cadastro_usuario/main.dart';
import 'package:cadastro_usuario/validadores.dart';

Finder campo(String rotulo) => find.widgetWithText(TextFormField, rotulo);

Future<void> digitar(WidgetTester tester, String rotulo, String texto) {
  return tester.enterText(campo(rotulo), texto);
}

Future<void> tocar(WidgetTester tester, String textoDoBotao) async {
  final botao = find.text(textoDoBotao);
  await tester.ensureVisible(botao);
  await tester.pumpAndSettle();
  await tester.tap(botao);
  await tester.pumpAndSettle();
}

Future<void> preencherTudoCerto(WidgetTester tester) async {
  await digitar(tester, 'Nome completo', 'Ana Beatriz Souza');
  await digitar(tester, 'E-mail', 'ana.souza@email.com');
  await digitar(tester, 'CPF', '52998224725');
  await digitar(tester, 'Telefone', '62999998888');
  await digitar(tester, 'Senha', 'abc123');
  await digitar(tester, 'Confirmar senha', 'abc123');
}

String textoDoCampo(WidgetTester tester, String rotulo) {
  return tester.widget<TextFormField>(campo(rotulo)).controller!.text;
}

void main() {
  group('Tela de cadastro', () {
    testWidgets('CADASTRAR vazio mostra um erro por campo e aviso vermelho',
        (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await tocar(tester, 'CADASTRAR');

      expect(find.text('Informe o seu nome completo.'), findsOneWidget);
      expect(find.text('Informe o seu e-mail.'), findsOneWidget);
      expect(find.text('Informe o seu CPF.'), findsOneWidget);
      expect(find.text('Informe o seu telefone.'), findsOneWidget);
      expect(find.text('Crie uma senha.'), findsOneWidget);
      expect(find.text('Repita a senha para confirmar.'), findsOneWidget);
      expect(
        find.text('Corrija 6 campos para concluir o cadastro.'),
        findsOneWidget,
      );
    });

    testWidgets('dados válidos mostram aviso de sucesso com o primeiro nome',
        (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await preencherTudoCerto(tester);
      await tocar(tester, 'CADASTRAR');

      expect(
        find.text('Cadastro concluído! Bem-vindo(a), Ana.'),
        findsOneWidget,
      );
    });

    testWidgets('e-mail sem @ é recusado', (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await preencherTudoCerto(tester);
      await digitar(tester, 'E-mail', 'ana.email.com');
      await tocar(tester, 'CADASTRAR');

      expect(find.text('O e-mail precisa ter o caractere @.'), findsOneWidget);
      expect(
        find.text('Corrija 1 campo para concluir o cadastro.'),
        findsOneWidget,
      );
    });

    testWidgets('CPF e telefone aceitam só números e no máximo 11',
        (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await digitar(tester, 'CPF', 'abc529.982.247-25999');
      await digitar(tester, 'Telefone', '(62) 99999-8888 77');
      await tester.pump();

      expect(textoDoCampo(tester, 'CPF'), '52998224725');
      expect(textoDoCampo(tester, 'Telefone'), '62999998888');
    });

    testWidgets('nome não aceita números', (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await digitar(tester, 'Nome completo', 'Ana2 Souza3');
      await tester.pump();

      expect(textoDoCampo(tester, 'Nome completo'), 'Ana Souza');
    });

    testWidgets('senhas diferentes são recusadas', (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await preencherTudoCerto(tester);
      await digitar(tester, 'Confirmar senha', 'abc124');
      await tocar(tester, 'CADASTRAR');

      expect(find.text('As senhas digitadas são diferentes.'), findsOneWidget);
    });

    testWidgets('o olho mostra e esconde a senha', (tester) async {
      await tester.pumpWidget(const AppCadastro());

      bool senhaEscondida() => tester
          .widget<EditableText>(
            find.descendant(
              of: campo('Senha'),
              matching: find.byType(EditableText),
            ),
          )
          .obscureText;

      final olho = find.descendant(
        of: campo('Senha'),
        matching: find.byType(IconButton),
      );

      expect(senhaEscondida(), isTrue);
      await tester.ensureVisible(olho);
      await tester.pumpAndSettle();
      await tester.tap(olho);
      await tester.pump();
      expect(senhaEscondida(), isFalse);

      await tester.tap(olho);
      await tester.pump();
      expect(senhaEscondida(), isTrue);
    });

    testWidgets('Limpar campos apaga o texto e os erros', (tester) async {
      await tester.pumpWidget(const AppCadastro());
      await digitar(tester, 'Nome completo', 'Ana');
      await tocar(tester, 'CADASTRAR');
      expect(find.text('Informe nome e sobrenome.'), findsOneWidget);

      // Espera o aviso vermelho sumir (ele fica 4 segundos na tela).
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tocar(tester, 'Limpar campos');

      expect(textoDoCampo(tester, 'Nome completo'), isEmpty);
      expect(find.text('Informe nome e sobrenome.'), findsNothing);
    });
  });

  group('Validadores', () {
    test('e-mail', () {
      expect(Validadores.email('ana@email.com'), isNull);
      expect(Validadores.email('ana@email'), isNotNull);
      expect(Validadores.email('@email.com'), isNotNull);
      expect(Validadores.email('ana email@x.com'), isNotNull);
    });

    test('CPF diz quantos dígitos faltam', () {
      expect(
        Validadores.cpf('123'),
        'CPF incompleto: falta(m) 8 dígito(s).',
      );
      expect(Validadores.cpf('52998224725'), isNull);
    });

    test('telefone com 10 ou 11 dígitos', () {
      expect(Validadores.telefone('6232221100'), isNull);
      expect(Validadores.telefone('62999998888'), isNull);
      expect(Validadores.telefone('999998888'), isNotNull);
    });

    test('senha com no mínimo 6 caracteres', () {
      expect(Validadores.senha('12345'), isNotNull);
      expect(Validadores.senha('123456'), isNull);
    });
  });
}
