import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Retorna a sessão ativa com o Token JWT
  static Session? get sessaoAtual => _client.auth.currentSession;

  // Retorna o Token JWT atual (útil para chamadas de API)
  static String? get accessToken => _client.auth.currentSession?.accessToken;

  // Stream para escutar mudanças de sessão em qualquer ecrã
  static Stream<AuthState> get estadoAutenticacao => _client.auth.onAuthStateChange;

  // Verificar se o utilizador está autenticado
  static bool get estaAutenticado => _client.auth.currentSession != null;

  // Método de Logout global
  static Future<void> encerrarSessao() async {
    await _client.auth.signOut();
  }
}