import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool isSending = false;

  void sendSOS() async {
    setState(() {
      isSending = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isSending = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("SOS animale in pericolo"),
        content: const Text("Segnalazione inviata (test)."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
        title: const Text("SOS Animale"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: isSending
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SOS animale in pericolo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 120,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                    ),
                    onPressed: sendSOS,
                    child: const Text("INVIA SOS"),
                  )
                ],
              ),
      ),
    );
  }
}
