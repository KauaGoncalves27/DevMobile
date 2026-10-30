import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'validadores.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  // Guardam o que o usuário digita em cada campo.
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _cpf = TextEditingController();
  final _telefone = TextEditingController();
  final _senha = TextEditingController();
  final _confirmacao = TextEditingController();

  late final _controles = [
    _nome,
    _email,
    _cpf,
    _telefone,
    _senha,
    _confirmacao,
  ];

  bool _senhaVisivel = false;
  bool _confirmacaoVisivel = false;

  // Antes da primeira tentativa os erros ficam escondidos. Depois que o
  // usuário clica em CADASTRAR, cada campo é revalidado enquanto ele digita.
  AutovalidateMode _modoValidacao = AutovalidateMode.disabled;

  @override
  void dispose() {
    for (final controle in _controles) {
      controle.dispose();
    }
    super.dispose();
  }

  void _cadastrar() {
    FocusScope.of(context).unfocus(); // fecha o teclado

    if (_formKey.currentState!.validate()) {
      final primeiroNome = _nome.text.trim().split(RegExp(r'\s+')).first;
      _mostrarAviso(
        'Cadastro concluído! Bem-vindo(a), $primeiroNome.',
        sucesso: true,
      );
      return;
    }

    setState(() => _modoValidacao = AutovalidateMode.onUserInteraction);
    final erros = _contarErros();
    _mostrarAviso(
      'Corrija $erros ${erros == 1 ? 'campo' : 'campos'} para concluir o cadastro.',
      sucesso: false,
    );
  }

  int _contarErros() {
    final resultados = [
      Validadores.nome(_nome.text),
      Validadores.email(_email.text),
      Validadores.cpf(_cpf.text),
      Validadores.telefone(_telefone.text),
      Validadores.senha(_senha.text),
      Validadores.confirmacao(_confirmacao.text, _senha.text),
    ];
    return resultados.where((erro) => erro != null).length;
  }

  void _limpar() {
    _formKey.currentState!.reset(); // tira as mensagens de erro
    for (final controle in _controles) {
      controle.clear(); // apaga o texto digitado
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _modoValidacao = AutovalidateMode.disabled);
  }

  void _mostrarAviso(String mensagem, {required bool sucesso}) {
    final largura = MediaQuery.sizeOf(context).width;
    final mensageiro = ScaffoldMessenger.of(context);

    mensageiro.hideCurrentSnackBar(); // evita empilhar avisos
    mensageiro.showSnackBar(
      SnackBar(
        width: largura > 520 ? 460 : null,
        backgroundColor:
            sucesso ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        content: Row(
          children: [
            Icon(
              sucesso ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // No navegador a tela é larga: centraliza o formulário com até 460px.
    final largura = MediaQuery.sizeOf(context).width;
    final margemLateral = largura > 520 ? (largura - 460) / 2 : 20.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de usuário')),
      body: Form(
        key: _formKey,
        autovalidateMode: _modoValidacao,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(margemLateral, 24, margemLateral, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Cabecalho(),
              const SizedBox(height: 28),

              // Nome: só letras, espaço e apóstrofo.
              TextFormField(
                controller: _nome,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ' ]")),
                ],
                validator: Validadores.nome,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  hintText: 'Ex.: Ana Beatriz Souza',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // E-mail: teclado com @ e sem espaços.
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                validator: Validadores.email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'nome@dominio.com',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 16),

              // CPF: teclado numérico, só dígitos, no máximo 11.
              TextFormField(
                controller: _cpf,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validadores.cpf,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente números',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Telefone: teclado de telefone, só dígitos, DDD + número.
              TextFormField(
                controller: _telefone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validadores.telefone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD + número, ex.: 62999998888',
                  prefixIcon: Icon(Icons.smartphone),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _senha,
                obscureText: !_senhaVisivel,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                validator: Validadores.senha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  helperText: 'Mínimo de 6 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: _BotaoOlho(
                    visivel: _senhaVisivel,
                    aoTocar: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmacao,
                obscureText: !_confirmacaoVisivel,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _cadastrar(),
                validator: (valor) =>
                    Validadores.confirmacao(valor, _senha.text),
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: _BotaoOlho(
                    visivel: _confirmacaoVisivel,
                    aoTocar: () => setState(
                      () => _confirmacaoVisivel = !_confirmacaoVisivel,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: _cadastrar,
                icon: const Icon(Icons.how_to_reg),
                label: const Text('CADASTRAR'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _limpar,
                child: const Text('Limpar campos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: tema.colorScheme.primaryContainer,
          child: Icon(
            Icons.person_add_alt_1,
            size: 34,
            color: tema.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nova conta',
          textAlign: TextAlign.center,
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Leva menos de um minuto. Todos os campos são obrigatórios.',
          textAlign: TextAlign.center,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: tema.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Ícone de olho que mostra ou esconde a senha.
class _BotaoOlho extends StatelessWidget {
  const _BotaoOlho({required this.visivel, required this.aoTocar});

  final bool visivel;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: visivel ? 'Esconder senha' : 'Mostrar senha',
      icon: Icon(visivel ? Icons.visibility_off : Icons.visibility),
      onPressed: aoTocar,
    );
  }
}
