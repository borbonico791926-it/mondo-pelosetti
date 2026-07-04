import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Collegamento ufficiale al tuo database Mondo Pelosetti
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
  final List<Marker> _markers = [];
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadReportsFromSupabase();
  }

  // Scarica le segnalazioni dal database online e le mette sulla mappa
  Future<void> _loadReportsFromSupabase() async {
    try {
      final List<dynamic> data = await Supabase.instance.client
          .from('reports')
          .select();

      setState(() {
        _markers.clear();
        for (var report in data) {
          if (report['latitude'] != null && report['longitude'] != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(report['id'].toString()),
                position: LatLng(report['latitude'], report['longitude']),
                infoWindow: InfoWindow(
                  title: report['title'],
                  snippet: "${report['type']}: ${report['description']}",
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      debugPrint("Errore nel caricamento dati: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mondo Pelosetti 🐾', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReportsFromSupabase,
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.9028, 12.4964), // Inizia centrata sull'Italia
          zoom: 6,
        ),
        markers: Set.from(_markers),
        onMapCreated: (controller) => _mapController = controller,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportScreen()),
          );
          _loadReportsFromSupabase(); // Aggiorna la mappa al ritorno
        },
        label: const Text('Segnala'),
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
  
  Position? _currentPosition;
  String _locationStatus = "Posizione non acquisita";

  // Cattura la posizione GPS del telefono
  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      setState(() { _locationStatus = "Acquisizione..."; });
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
          _locationStatus = "📍 Posizione acquisita correttamente";
        });
      } catch (e) {
        setState(() { _locationStatus = "Errore GPS"; });
      }
    } else {
      setState(() { _locationStatus = "Permesso negato"; });
    }
  }

  // Invia i dati inseriti nel modulo direttamente al database online
  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('reports').insert({
          'type': _type,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'latitude': _currentPosition?.latitude,
          'longitude': _currentPosition?.longitude,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Segnalazione salvata online con successo! 🎉')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'invio online: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titolo', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci un titolo' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrizione', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Inserisci una descrizione' : null,
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.amber),
                  title: Text(_locationStatus, style: const TextStyle(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.gps_fixed, color: Colors.blue),
                    onPressed: _getLocation,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text('Invia Online', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
