import 'package:flutter/material.dart';
import '../data/animal.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animale;

  const AnimalDetailScreen({
    super.key,
    required this.animale,
  });

  Widget sezione(String titolo, String testo, IconData icona) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Icon(
                  icona,
                  color: Colors.orange,
                ),

                const SizedBox(width: 10),

                Text(
                  titolo,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              testo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(animale.nome),
      ),


      body: SingleChildScrollView(

        child: Column(

          children: [


            Container(

              height: 230,

              width: double.infinity,

              color: Colors.orange.shade100,

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Image.asset(

                  animale.immagine,

                  fit: BoxFit.contain,

                ),

              ),

            ),



            Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [


                  Text(

                    animale.nome,

                    style: const TextStyle(

                      fontSize: 30,

                      fontWeight: FontWeight.bold,

                    ),

                  ),


                  const SizedBox(height: 5),


                  Text(

                    "Categoria: ${animale.categoria}",

                    style: const TextStyle(

                      fontSize: 18,

                    ),

                  ),


                  const SizedBox(height: 15),



                  sezione(

                    "🐾 Informazioni",

                    animale.descrizione,

                    Icons.pets,

                  ),



                  sezione(

                    "⚖️ Peso medio",

                    animale.peso,

                    Icons.monitor_weight,

                  ),



                  sezione(

                    "❤️ Vita media",

                    animale.vitaMedia,

                    Icons.favorite,

                  ),



                  sezione(

                    "🍖 Alimentazione",

                    animale.alimentazione,

                    Icons.restaurant,

                  ),



                  sezione(

                    "💡 Curiosità",

                    animale.curiosita,

                    Icons.lightbulb,

                  ),



                  sezione(

                    "⚠️ Problemi comuni",

                    animale.problemiComuni,

                    Icons.warning,

                  ),



                  const SizedBox(height: 10),



                  Card(

                    color: Colors.orange.shade100,

                    child: const Padding(

                      padding: EdgeInsets.all(16),

                      child: Text(

                        "❤️ Consiglio Mondo Pelosetti:\n\n"

                        "Questa app offre informazioni e consigli generali. "

                        "Per problemi di salute importanti rivolgersi sempre a un veterinario.",

                        style: TextStyle(

                          fontSize: 16,

                        ),

                      ),

                    ),

                  ),


                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}