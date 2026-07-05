import 'package:flutter/material.dart';
import 'sos_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Collegamento sicuro a Supabase con le tue credenziali
  await Supabase.initialize(
    url: 'https://supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBieXVuYWNjeHRmYmVvZndzaHJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5Nzg4MTcsImV4cCI6MjAzMTU1NDgxN30.08X0BTh0Sg5m1N_wE5H8f-G9-Uf_yE7oN_O7Z1k9vY8',
  );

  runApp(const MondoPelosettiApp());
}

class MondoPelosettiApp extends StatelessWidget {
  const MondoPelosettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mondo Pelosetti',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const AuthCheckScreen(),
    );
  }
}

// Controllo automatico dello stato dell'utente (Se è già loggato o no)
class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const MainDashboard();
    } else {
      return const LoginScreen();
    }
  }
}

// Schermata di Accesso (Email o Google) - Derivata dal codice #53
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmail() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore di accesso: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Avvia il sistema nativo di accesso con Google
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mondo Pelosetti - Accedi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signInWithEmail,
                    child: const Text('Accedi con Email'),
                  ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.g_mobiledata, size: 30),
              label: const Text('Accedi con Google'),
            ),
          ],
        ),
      ),
    );
  }
}

// Schermata Principale Gestione Animali e Soccorsi - Derivata dal codice #43
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _reportController = TextEditingController();
  List<dynamic> _reports = [];
  bool _isLoadingReports = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // Caricamento logico delle segnalazioni dal database Supabase
  Future<void> _loadReports() async {
    setState(() => _isLoadingReports = true);
    try {
      final data = await Supabase.instance.client
          .from('reports')
          .select()
          .order('created_at', ascending: false);
      setState(() => _reports = data);
    } catch (e) {
      // Gestione pacifica in caso di tabella non ancora pronta
      print('Info caricamento: $e');
    } finally {
      setState(() => _isLoadingReports = false);
    }
  }

  // Invio di un nuovo report o soccorso animale al database
  Future<void> _submitReport() async {
    if (_reportController.text.trim().isEmpty) return;
    try {
      await Supabase.instance.client.from('reports').insert({
        'description': _reportController.text.trim(),
        'status': 'In attesa',
      });
      _reportController.clear();
      _loadReports();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Segnalazione inviata con successo!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore invio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mondo Pelosetti - Soccorsi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text('Segnala un animale da soccorrere', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextField(
                      controller: _reportController,
                      decoration: const InputDecoration(hintText: 'Inserisci dettagli o luogo...'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submitReport,
                      child: const Text('Invia Segnalazione'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Segnalazioni Attive:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: _isLoadingReports
                  ? const Center(child: CircularProgressIndicator())
                  : _reports.isEmpty
                      ? const Center(child: Text('Nessun animale segnalato al momento.'))
                      : ListView.builder(
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final item = _reports[index];
                            return ListTile(
                              leading: const Icon(Icons.pets, color: Colors.orange),
                              title: Text(item['description'] ?? 'Nessuna descrizione'),
                              trailing: Chip(label: Text(item['status'] ?? 'Aperto')),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
