import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  String? animaleSelezionato;
  String? razzaSelezionata;

  final TextEditingController etaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController problemaController = TextEditingController();

  final List<String> animali = [
    "Cane",
    "Gatto",
    "Coniglio",
    "Uccello",
    "Tartaruga",
    "Pesce",
    "Roditore",
    "Rettile",
    "Altro animale domestico",
  ];

  final List<String> razze = [
    "Meticcio",
    "Labrador",
    "Golden Retriever",
    "Pastore Tedesco",
    "Chihuahua",
    "Persiano",
    "Maine Coon",
    "Europeo",
    "Altra razza",
  ];

  void inviaSOS() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("S.O.S. Animale in pericolo"),
        content: const Text(
          "Segnalazione inviata (test).",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S.O.S. Animale in pericolo"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Tipo di animale",
                border: OutlineInputBorder(),
              ),
             initialValue: animaleSelezionato,
              items: animali.map((animale) {
                return DropdownMenuItem(
                  value: animale,
                  child: Text(animale),
                );
              }).toList(),
              onChanged: (valore) {
                setState(() {
                  animaleSelezionato = valore;
                });
              },
            ),

            const SizedBox(height: 15), 

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Razza",
                border: OutlineInputBorder(),
              ),
              initialValue: razzaSelezionata,
              items: razze.map((razza) {
                return DropdownMenuItem(
                  value: razza,
                  child: Text(razza),
                );
              }).toList(),
              onChanged: (valore) {
                setState(() {
                  razzaSelezionata = valore;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: etaController,
              decoration: const InputDecoration(
                labelText: "Età dell'animale",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: pesoController,
              decoration: const InputDecoration(
                labelText: "Peso (kg)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: problemaController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Descrivi il problema",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo),
              label: const Text("Aggiungi foto"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on),
              label: const Text("Usa la mia posizione"),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(18),
                ),
                onPressed: inviaSOS,
                child: const Text(
                  "INVIA SOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}