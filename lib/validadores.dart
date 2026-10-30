/// Regras de validação da tela de cadastro.
///
/// Cada função recebe o texto digitado e devolve a mensagem de erro,
/// ou `null` quando o valor está correto (é assim que o `validator`
/// do TextFormField entende que o campo é válido).
class Validadores {
  Validadores._();

  /// Formato nome@dominio.extensao (ex.: ana.souza@email.com).
  static final RegExp _formatoEmail =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static final RegExp _somenteDigitos = RegExp(r'^[0-9]+$');

  static String? nome(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Informe o seu nome completo.';
    }
    if (!texto.contains(' ')) {
      return 'Informe nome e sobrenome.';
    }
    return null;
  }

  static String? email(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Informe o seu e-mail.';
    }
    if (!texto.contains('@')) {
      return 'O e-mail precisa ter o caractere @.';
    }
    if (!_formatoEmail.hasMatch(texto)) {
      return 'Formato inválido. Exemplo: nome@dominio.com';
    }
    return null;
  }

  static String? cpf(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Informe o seu CPF.';
    }
    if (!_somenteDigitos.hasMatch(texto)) {
      return 'Use apenas números no CPF.';
    }
    if (texto.length < 11) {
      final faltam = 11 - texto.length;
      return 'CPF incompleto: falta(m) $faltam dígito(s).';
    }
    if (texto.length > 11) {
      return 'O CPF tem apenas 11 dígitos.';
    }
    return null;
  }

  static String? telefone(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Informe o seu telefone.';
    }
    if (!_somenteDigitos.hasMatch(texto)) {
      return 'Use apenas números no telefone.';
    }
    if (texto.length < 10 || texto.length > 11) {
      return 'Digite DDD + número (10 ou 11 dígitos).';
    }
    return null;
  }

  static String? senha(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Crie uma senha.';
    }
    if (texto.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }
    return null;
  }

  static String? confirmacao(String? valor, String senhaDigitada) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Repita a senha para confirmar.';
    }
    if (texto != senhaDigitada) {
      return 'As senhas digitadas são diferentes.';
    }
    return null;
  }
}
