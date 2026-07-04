import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.amber,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mondo Pelosetti 🐾',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pets,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'Benvenuto su Mondo Pelosetti!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'L\'app per segnalare e aiutare gli animali smarriti o feriti nella tua zona.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportScreen()),
                  );
                },
                icon: const Icon(Icons.report_problem),
                label: const Text('Invia una Segnalazione'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
  
  String _locationStatus = "Posizione non acquisita";
  String _imageStatus = "Nessuna foto selezionata";

  // Funzione per acquisire il GPS
  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      setState(() { _locationStatus = "Acquisizione in corso..."; });
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _locationStatus = "📍 Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
        });
      } catch (e) {
        setState(() { _locationStatus = "Errore nel recupero GPS"; });
      }
    } else {
      setState(() { _locationStatus = "Permesso GPS negato"; });
    }
  }

  // Funzione per scattare/scegliere una foto
  Future<void> _pickImage() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageStatus = "📸 Foto selezionata correttamente!";
        });
      }
    } else {
      setState(() { _imageStatus = "Permesso fotocamera negato"; });
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
              const Text(
                'Seleziona il tipo di segnalazione:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Smarrito', 'Avvistato', 'Ferito', 'In Pericolo']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() { _type = value!; });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titolo (es. Cane smarrito, Gatto ferito)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Inserisci un titolo';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrizione (es. razza, colore, dettagli)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Inserisci una descrizione';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Sezione Allegati (Foto e Posizione)
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.amber),
                        title: Text(_locationStatus, style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.gps_fixed, color: Colors.blue),
                          onPressed: _getLocation,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.image, color: Colors.amber),
                        title: Text(_imageStatus, style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Segnalazione salvata localmente!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text('Invia Segnalazione', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
