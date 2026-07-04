import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3bXlra3NpZHNqcWttZG50d2FtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI5OTE1ODQsImV4cCI6MjA5ODU2NzU4NH0.kAeYDYFIryV3CA_HZgo5LNXWCxt0K21I6Q2KxIINlE8',
  );
  runApp(const MondoPelosettiApp());
}

class MondoPelosettiApp extends StatelessWidget {
  const MondoPelosettiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mondo Pelosetti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      if (_isSignUp) {
        await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrazione completata! Controlla la tua email.')));
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: $e')));
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.mondopelosetti://login-callback',
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore Google Login: $e')));
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
      appBar: AppBar(
        title: Text(_isSignUp ? 'Registrati 🐾' : 'Accedi 🐾', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.pets, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              Text(_isSignUp ? 'Crea un nuovo account' : 'Bentornato su Mondo Pelosetti!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress, validator: (v) => v == null || v.isEmpty ? 'Inserisci l\'email' : null),
              const SizedBox(height: 20),
              TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true, validator: (v) => v == null || v.length < 6 ? 'La password deve avere almeno 6 caratteri' : null),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleAuth,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text(_isSignUp ? 'Registrati' : 'Accedi', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                label: const Text('Accedi con Google Account', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: () => setState(() { _isSignUp = !_isSignUp; }), child: Text(_isSignUp ? 'Hai già un account? Accedi' : 'Non hai un account? Registrati')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() { _isLoading = true; });
    try {
      final List<dynamic> data = await Supabase.instance.client.from('reports').select().order('created_at', ascending: false);
      setState(() { _reports = data; _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mondo Pelosetti 🐾', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.amber,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _logout),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadReports)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(child: Text('Nessuna segnalazione presente.', style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.pets, color: Colors.white)),
                        title: Text(report['title'] ?? 'Senza titolo', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${report['type']} • ${report['animal_specie'] ?? 'N/A'} (${report['animal_breed'] ?? 'Meticcio'})\n${report['description']}"),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
          _loadReports();
        },
        label: const Text('Nuova Segnalazione'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Smarrito';
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _specie = TextEditingController();
  final _breed = TextEditingController();
  List<String> _specieList = [];
  List<String> _breedList = [];

  Future<void> _searchSpecie(String q) async {
    if (q.isEmpty) { setState(() { _specieList = []; }); return; }
    try {
      final res = await http.get(Uri.parse('https://wikipedia.org'));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        if (data.length > 1 && data[1] is List) {
          setState(() { _specieList = List<String>.from(data[1]); });
        }
      }
    } catch (e) {
      debugPrint("Errore: $e");
    }
  }

  Future<void> _searchBreed(String q) async {
    if (q.isEmpty) { setState(() { _breedList = []; }); return; }
    String queryCompleta = _specie.text.isNotEmpty ? "${_specie.text} $q" : q;
    try {
      final res = await http.get(Uri.parse('https://wikipedia.org'));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        if (data.length > 1 && data[1] is List) {
