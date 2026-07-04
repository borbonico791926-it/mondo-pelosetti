import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3bXlra3NpZHNqcWttZG50d2FtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI5OTE1ODQsImV4cCI6MjA5ODU2NzU4NH0.kAeYDYFIryV3CA_HZgo5LNXWCxt0K21I6Q2KxIINlE8',
  );
  runApp(const MaterialApp(home: AuthScreen(), debugShowCheckedModeBanner: false));
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isSignUp = false;

  void _submit() async {
    try {
      if (_isSignUp) {
        await Supabase.instance.client.auth.signUp(email: _email.text.trim(), password: _password.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Controlla la tua email!')));
      } else {
        await Supabase.instance.client.auth.signInWithPassword(email: _email.text.trim(), password: _password.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accesso eseguito!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: $e')));
    }
  }

  void _googleLogin() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore Google: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_isSignUp ? 'Registrati 🐾' : 'Accedi 🐾'), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 70, color: Colors.amber),
            const SizedBox(height: 20),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size.fromHeight(45)),
              child: Text(_isSignUp ? 'Crea Account' : 'Entra', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _googleLogin,
              icon: const Icon(Icons.account_circle, color: Colors.red),
              label: const Text('Accedi con Google'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp ? 'Hai già un account? Accedi' : 'Nuovo utente? Registrati'),
            )
          ],
        ),
      ),
    );
  }
}
