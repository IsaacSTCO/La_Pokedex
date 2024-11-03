import 'package:flutter/material.dart';
import '../services/pokemon_service.dart';
import '../models/pokemon_type.dart';
import 'pokemon_type_list_screen.dart';

class TypesTab extends StatelessWidget {
  final PokemonService _service = PokemonService();

  TypesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _service.getTypes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final type = snapshot.data![index];
              
              return FutureBuilder<int>(
                future: _service.getPokemonCountByType(type), // Obtener conteo de Pokémon
                builder: (context, countSnapshot) {
                  if (countSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final cantidadPokemon = countSnapshot.data ?? 0;

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonTypeListScreen(type: type),
                      ),
                    ),
                    child: Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            PokemonType.typeImages[type]!,
                            height: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            PokemonType.typeNames[type] ?? type.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Mostrar la cantidad de Pokémon
                          Text(
                            '$cantidadPokemon Pokémon',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
