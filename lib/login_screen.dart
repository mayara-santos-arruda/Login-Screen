import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/gradient_button.dart';
import 'package:login_flutter/widgets/login_field.dart';
import 'package:login_flutter/widgets/social_button.dart';
import 'pallete.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login_flutter/home_screen.dart';

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; 
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

  void _mostrarNotificacao({
    required String mensagem,
    required bool ehSucesso,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: ehSucesso
                ? [
                    Pallete.gradient2,
                    Pallete.gradient3,
                  ]
                : [
                    Pallete.gradient1, 
                    Pallete.borderColor,
                  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (ehSucesso ? Colors.green : Colors.red).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ehSucesso ? Icons.check_circle_outline : Icons.error_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mensagem,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarNotificacao(
        mensagem: 'Por favor, preencha todos os campos.',
        ehSucesso: false,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (mounted && response.user != null) {
        _mostrarNotificacao(
          mensagem: 'Login realizado com sucesso! Bem-vindo(a)',
          ehSucesso: true,
        );
        
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on AuthException catch (e) {
      String mensagemTratada = 'Erro ao fazer login.';

      if (e.message.contains('Invalid login credentials')) {
        mensagemTratada = 'E-mail ou senha incorretos.';
      } else if (e.message.contains('Email not confirmed')) {
        mensagemTratada = 'Por favor, confirme o seu e-mail antes de entrar.';
      } else {
        mensagemTratada = e.message;
      }

      _mostrarNotificacao(
        mensagem: mensagemTratada,
        ehSucesso: false,
      );
    } catch (e) {
      _mostrarNotificacao(
        mensagem: 'Ocorreu um erro de conexão. Tente novamente.',
        ehSucesso: false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginComGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback',
      );
    } on AuthException catch (e) {
      _mostrarNotificacao(
        mensagem: 'Erro Google: ${e.message}',
        ehSucesso: false,
      );
    }
  }

  Future<void> _loginComFacebook() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'https://tmenhnzkxraofqmitkdz.supabase.co/auth/v1/callback',
      );
    } on AuthException catch (e) {
      _mostrarNotificacao(
        mensagem: 'Erro Facebook: ${e.message}',
        ehSucesso: false,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ScrollConfiguration(
                behavior: NoScrollbarBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(1.5), // Largura da borda
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Pallete.gradient1.withOpacity(0.6),
                              Pallete.gradient2.withOpacity(0.6),
                              Pallete.gradient3.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Pallete.gradient3.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D0A1A).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Faça seu ',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Pallete.gradient1,
                                          Pallete.gradient2,
                                          Pallete.gradient3,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                              SocialButton(
                                iconName: 'google.png',
                                label: 'Entrar com Google',
                                horizontalPadding: 70.0,
                                onPressed: _loginComGoogle,
                              ),
                              const SizedBox(height: 15),
                              SocialButton(
                                iconName: 'facebook.png',
                                label: 'Entrar com Facebook',
                                horizontalPadding: 60.0,
                                onPressed: _loginComFacebook,
                              ),
                              const SizedBox(height: 20),

                              const Text('ou', style: TextStyle(fontSize: 17)),
                              const SizedBox(height: 20),

                              LoginField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email,
                              ),

                              const SizedBox(height: 15),

                              LoginField(
                              controller: _passwordController,
                              hintText: 'Senha',
                              icon: Icons.lock,
                              obscureText: true,
                              isPassword: true,
                              
                              ),
                              const SizedBox(height: 20),

  _isLoading
   ? CircularProgressIndicator(color: Pallete.gradient2)
  : GradientButton(
    onPressed: _fazerLogin,
    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}