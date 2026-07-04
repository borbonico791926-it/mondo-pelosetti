import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
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
    _loadReportsFromSupabase();
  }

  Future<void> _loadReportsFromSupabase() async {
    setState(() { _isLoading = true; });
    try {
      final List<dynamic> data = await Supabase.instance.client
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _reports = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
      debugPrint("Errore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mondo Pelosetti 🐾', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReportsFromSupabase,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(child: Text('Nessuna segnalazione. Sii il primo!', style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.pets, color: Colors.white),
                        ),
                        title: Text(report['title'] ?? 'Senza titolo', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${report['type']} • ${report['animal_specie'] ?? 'Non specificato'} (${report['animal_breed'] ?? 'Meticcio'})\n${report['description']}"),
                        trailing: const Icon(Icons.chevron_right),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportScreen()),
          );
          _loadReportsFromSupabase();
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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final _specieController = TextEditingController();
  final _breedController = TextEditingController();
  
  List<String> _speciesSuggestions = [];
  List<String> _breedSuggestions = [];

  Future<void> _searchSpeciesExternal(String query) async {
    if (query.isEmpty) {
      setState(() { _speciesSuggestions = []; });
      return;
    }
    try {
      final response = await http.get(Uri.parse('https://wikipedia.org'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.length > 1 && data[1] is List) {
          setState(() {
            _speciesSuggestions = List<String>.from(data[1]);
          });
        }
      }
    } catch (e) {
      debugPrint("Errore specie: $e");
    }
  }

  Future<void> _searchBreedsExternal(String query) async {
    if (query.isEmpty) {
      setState(() { _breedSuggestions = []; });
      return;
    }
    String specieContext = _specieController.text.isNotEmpty ? "${_specieController.text} " : "";
    try {
      final response = await http.get(Uri.parse('https://wikipedia.org'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.length > 1 && data[1] is List) {
          setState(() {
            _breedSuggestions = List<String>.from(data[1]).map((item) {
              return item.replaceAll(RegExp(specieContext, caseSensitive: false), '').trim();
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Errore razze: $e");
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('reports').insert({
          'type': _type,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'animal_specie': _specieController.text,
          'animal_breed': _breedController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Segnalazione salvata online con successo! 🎉')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nell\'invio: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _specieController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Segnalazione 📢', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Smarrito', 'Avvistato', 'Ferito', 'In Pericolo']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) => setState(() { _type = value!; }),
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _specieController,
                decoration: const InputDecoration(
                  labelText: 'Tipo di animale (es: Cane, Gatto...)', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchSpeciesExternal,
                validator: (value) => value == null || value.isEmpty ? 'Inserisci il tipo di animale' : null,
              ),
              if (_speciesSuggestions.isNotEmpty)
                Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
                  child: ListView.builder(
                    itemCount: _speciesSuggestions.length,
                    itemBuilder: (context, idx) {
                      return ListTile(
                        title: Text(_speciesSuggestions[idx]),
                        dense: true,
                        onTap: () {
                          setState(() {
                            _specieController.text = _speciesSuggestions[idx];
                            _speciesSuggestions = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Razza (es: Pastore Tedesco, Siamese...)', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                onChanged: _searchBreedsExternal,
              ),
              if (_breedSuggestions.isNotEmpty)
                Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 10),
