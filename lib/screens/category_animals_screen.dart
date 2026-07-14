import 'package:flutter/material.dart';
import '../data/animals_data.dart';
import '../widgets/animal_card.dart';

import 'animal_detail_screen.dart';


class CategoryAnimalsScreen extends StatelessWidget {

  final String categoria;


  const CategoryAnimalsScreen({
    super.key,
    required this.categoria,
  });



  @override
  Widget build(BuildContext context) {


    final animaliCategoria = elencoAnimali.where((animale) {

      return animale.categoria == categoria;

    }).toList();



    return Scaffold(

      appBar: AppBar(

        title: Text(
          categoria,
        ),

      ),


      body: ListView(

        children: animaliCategoria.map((animale) {


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


        }).toList(),

      ),

    );

  }

}