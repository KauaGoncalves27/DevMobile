import 'package:flutter/material.dart';

import 'tela_cadastro.dart';

void main() {
  runApp(const AppCadastro());
}

class AppCadastro extends StatelessWidget {
  const AppCadastro({super.key});

  // Visual em preto e branco. Só os avisos têm cor: verde (sucesso) e
  // vermelho (erro).
  static const Color corPrincipal = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    );

    return MaterialApp(
      title: 'Cadastro de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrincipal,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome, // tons de cinza
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: corPrincipal,
          foregroundColor: Colors.white,
        ),
        // Visual padrão de todos os campos do formulário.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: borda,
          enabledBorder: borda,
          focusedBorder: borda.copyWith(
            borderSide: const BorderSide(color: corPrincipal, width: 2),
          ),
          errorMaxLines: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrincipal,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const TelaCadastro(),
    );
  }
}
