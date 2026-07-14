import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categorie = const [

    {
      "nome": "Cani",
      "icona": Icons.pets,
    },

    {
      "nome": "Gatti",
      "icona": Icons.pets,
    },

    {
      "nome": "Uccelli",
      "icona": Icons.flutter_dash,
    },

    {
      "nome": "Tartarughe",
      "icona": Icons.water,
    },

    {
      "nome": "Pesci",
      "icona": Icons.water,
    },

    {
      "nome": "Conigli",
      "icona": Icons.cruelty_free,
    },

    {
      "nome": "Roditori",
      "icona": Icons.mouse,
    },

  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Categorie Animali 🐾",
        ),
      ),


      body: GridView.builder(

        padding: const EdgeInsets.all(16),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,

          crossAxisSpacing: 15,

          mainAxisSpacing: 15,

        ),


        itemCount: categorie.length,


        itemBuilder: (context, index) {


          final categoria = categorie[index];


          return Card(

            child: InkWell(

              borderRadius: BorderRadius.circular(20),

              onTap: () {

                // Qui collegheremo gli animali della categoria

              },


              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,


                children: [


                  Icon(

                    categoria["icona"],

                    size: 50,

                    color: Colors.orange,

                  ),


                  const SizedBox(height: 15),


                  Text(

                    categoria["nome"],

                    style: const TextStyle(

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ],

              ),

            ),

          );

        },

      ),

    );

  }

}