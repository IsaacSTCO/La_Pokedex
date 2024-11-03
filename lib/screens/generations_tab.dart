import 'package:flutter/material.dart';
import '../services/pokemon_service.dart';
import 'pokemon_generation_list_screen.dart';

class GenerationsTab extends StatelessWidget {
  // Aquí puedes cambiar los nombres de las regiones o añadir más si salen nuevas
  final Map<int, String> nombresRegiones = {
    1: '🌿 Kanto',      // Puedes cambiar los emojis o quitarlos
    2: '🍃 Johto',      // si no te gustan
    3: '🌺 Hoenn',
    4: '❄️ Sinnoh',
    5: '🌆 Unova',
    6: '🌸 Kalos',
    7: '🏖️ Alola',
    8: '☁️ Galar',
    9: '🎓 Paldea',
  };

  // Puedes personalizar los colores de cada generación
  final Map<int, Color> coloresGeneraciones = {
    1: Colors.red[300]!,
    2: Colors.blue[300]!,
    3: Colors.green[300]!,
    4: Colors.purple[300]!,
    5: Colors.orange[300]!,
    6: Colors.pink[300]!,
    7: Colors.teal[300]!,
    8: Colors.indigo[300]!,
    9: Colors.amber[300]!,
  };

   GenerationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      // Puedes cambiar el número de columnas aquí
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.3,  // Cambia esto para hacer las tarjetas más altas o anchas
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 9,  // Aumenta este número si sale una nueva generación
      itemBuilder: (context, index) {
        final generacion = index + 1;
        final rango = PokemonService.generationRanges[generacion]!;
        final cantidadPokemon = rango[1] - rango[0] + 1;
        
        // Aquí puedes personalizar cómo se ve cada tarjeta de generación
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PokemonGenerationListScreen(generation: generacion),
            ),
          ),
          child: Card(
            // Puedes cambiar el color de fondo de las tarjetas
            color: coloresGeneraciones[generacion],
            elevation: 5,  // Cambia esto para más o menos sombra
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Cambia el redondeo aquí
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Puedes personalizar los estilos de texto
                Text(
                  'Generación $generacion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,  // Cambia el color del texto
                    shadows: [  // Puedes quitar o modificar la sombra del texto
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  nombresRegiones[generacion]!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                // Puedes cambiar cómo se muestra la cantidad de Pokémon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$cantidadPokemon Pokémon',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}