import 'package:flutter/material.dart';

import '../data/animals_data.dart';
import '../widgets/dashboard_button.dart';
import '../widgets/category_card.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/section_title.dart';
import '../widgets/animal_card.dart';

import 'animal_detail_screen.dart';
import 'categories_screen.dart';
import 'category_animals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  String ricerca = "";


  @override
  Widget build(BuildContext context) {


    final animaliFiltrati = elencoAnimali.where((animale) {

      return animale.nome.toLowerCase().contains(ricerca) ||
          animale.categoria.toLowerCase().contains(ricerca);

    }).toList();



    final categorie = [

      {
        "nome": "Cani",
        "icona": Icons.pets,
        "colore": Colors.brown,
      },

      {
        "nome": "Gatti",
        "icona": Icons.pets,
        "colore": Colors.orange,
      },

      {
        "nome": "Conigli",
        "icona": Icons.cruelty_free,
        "colore": Colors.pink,
      },

      {
        "nome": "Tartarughe",
        "icona": Icons.water,
        "colore": Colors.green,
      },

      {
        "nome": "Pesci",
        "icona": Icons.water,
        "colore": Colors.blue,
      },

      {
        "nome": "Uccelli",
        "icona": Icons.flutter_dash,
        "colore": Colors.purple,
      },

    ];



    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "🐾 Mondo Pelosetti",
        ),

      ),


      body: SingleChildScrollView(

        child: Column(

          children: [


            Container(

              margin: const EdgeInsets.all(16),

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.orange.shade100,

                borderRadius:
                    BorderRadius.circular(20),

              ),

              child: const Column(

                children: [

                  Text(

                    "Benvenuto nel mondo degli animali ❤️",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  SizedBox(height: 10),

                  Text(

                    "Informazioni, consigli e aiuto per i nostri amici pelosetti.",

                    textAlign: TextAlign.center,

                  ),

                ],

              ),

            ),



            const SectionTitle(

              titolo: "Menu principale",

              icona: Icons.pets,

            ),



            Padding(

              padding: const EdgeInsets.all(16),

              child: GridView.count(

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,


                children: [

                  DashboardButton(

                    title: "Cani",

                    icon: Icons.pets,

                    color: Colors.brown,

                    onTap: () {},

                  ),


                  DashboardButton(

                    title: "Gatti",

                    icon: Icons.pets,

                    color: Colors.orange,

                    onTap: () {},

                  ),


                  DashboardButton(

                    title: "SOS Animali",

                    icon: Icons.warning,

                    color: Colors.red,

                    onTap: () {},

                  ),


                  DashboardButton(

                    title: "Categorie",

                    icon: Icons.category,

                    color: Colors.green,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                              const CategoriesScreen(),

                        ),

                      );

                    },

                  ),

                ],

              ),

            ),



            const DailyTipCard(

              titolo:
                  "Consiglio del giorno",

              testo:
                  "Controlla sempre alimentazione, acqua e salute del tuo amico a quattro zampe.",

            ),



            const SectionTitle(

              titolo: "Categorie animali",

              icona: Icons.category,

            ),



            Padding(

              padding: const EdgeInsets.all(16),

              child: GridView.builder(

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount: categorie.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                ),


                itemBuilder: (context, index) {

                  final categoria = categorie[index];


                 return CategoryCard(
 
                    titolo: categoria["nome"] as String,

                    icona: categoria["icona"] as IconData,

                    colore: categoria["colore"] as Color,

                    onTap: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (context) =>
          CategoryAnimalsScreen(
            categoria: categoria["nome"] as String,
          ),

    ),

  );

},

                  );

                },

              ),

            ),



            const SectionTitle(

              titolo: "Cerca un animale",

              icona: Icons.search,

            ),



            Padding(

              padding:
                  const EdgeInsets.symmetric(horizontal: 16),

              child: TextField(

                decoration: InputDecoration(

                  hintText:
                      "Cerca per nome o categoria...",

                  prefixIcon:
                      const Icon(Icons.search),

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(15),

                  ),

                ),


                onChanged: (value) {

                  setState(() {

                    ricerca =
                        value.toLowerCase();

                  });

                },

              ),

            ),



            const SectionTitle(

              titolo: "I nostri animali",

              icona: Icons.favorite,

            ),



            ...animaliFiltrati.map((animale) {

              return AnimalCard(

                nome: animale.nome,

                categoria: animale.categoria,

                descrizione: animale.descrizione,

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>
                          AnimalDetailScreen(

                            animale: animale,

                          ),

                    ),

                  );

                },

              );

            }),



            const SizedBox(height: 20),

          ],

        ),

      ),

    );

  }

}