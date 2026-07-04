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
      home: const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mondo Pelosetti 🐾', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.amber,
        centerTitle: true,
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
        final List<dynamic> data = json.decode(res.body);
        if (data.length > 1 && data[1] is List) { setState(() { _specieList = List<String>.from(data[1]); }); }
      }
    } catch (e) { debugPrint("$e"); }
  }

  Future<void> _searchBreed(String q) async {
    if (q.isEmpty) { setState(() { _breedList = []; }); return; }
    String ctx = _specie.text.isNotEmpty ? "${_specie.text} " : "";
    try {
      final res = await http.get(Uri.parse('https://wikipedia.org'));
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        if (data.length > 1 && data[1] is List) {
          setState(() { _breedList = List<String>.from(data[1]).map((i) => i.replaceAll(RegExp(ctx, caseSensitive: false), '').trim()).toList(); });
        }
      }
    } catch (e) { debugPrint("$e"); }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('reports').insert({
          'type': _type, 'title': _title.text, 'description': _desc.text, 'animal_specie': _specie.text, 'animal_breed': _breed.text,
        });
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore invio: $e')));
      }
    }
  }

  @override
  void dispose() { _title.dispose(); _desc.dispose(); _specie.dispose(); _breed.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova Segnalazione 📢', style: TextStyle(color: Colors.white)), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Smarrito', 'Avvistato', 'Ferito', 'In Pericolo'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() { _type = v!; }),
              ),
              const SizedBox(height: 15),
              TextFormField(controller: _specie, decoration: const InputDecoration(labelText: 'Tipo di animale', border: OutlineInputBorder()), onChanged: _searchSpecie, validator: (v) => v == null || v.isEmpty ? 'Campo richiesto' : null),
              if (_specieList.isNotEmpty) Container(height: 80, color: Colors.amber.shade50, child: ListView.builder(itemCount: _specieList.length, itemBuilder: (c, i) => ListTile(title: Text(_specieList[i]), dense: true, onTap: () => setState(() { _specie.text = _specieList[i]; _specieList = []; })))),
              const SizedBox(height: 15),
              TextFormField(controller: _breed, decoration: const InputDecoration(labelText: 'Razza', border: OutlineInputBorder()), onChanged: _searchBreed),
              if (_breedList.isNotEmpty) Container(height: 80, color: Colors.amber.shade50, child: ListView.builder(itemCount: _breedList.length, itemBuilder: (c, i) => ListTile(title: Text(_breedList[i]), dense: true, onTap: () => setState(() { _breed.text = _breedList[i]; _breedList = []; })))),
              const SizedBox(height: 15),
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Titolo', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Campo richiesto' : null),
              const SizedBox(height: 15),
              TextFormField(controller: _desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Descrizione', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Campo richiesto' : null),
              const SizedBox(height: 25),
              ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('Invia Online', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
