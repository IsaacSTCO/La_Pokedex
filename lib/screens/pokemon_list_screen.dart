import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/pokemon_type.dart';

class PokemonListScreen extends StatelessWidget {
  final String title;
  final Future<List<Pokemon>> Function() loadPokemons;

  const PokemonListScreen({super.key, 
    required this.title,
    required this.loadPokemons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Pokemon>>(
        future: loadPokemons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pokemon = snapshot.data![index];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        pokemon.imageUrl,
                        height: 100,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 100);
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        pokemon.name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        children: pokemon.types.map((type) => Chip(
                          label: Text(
                            PokemonType.typeNames[type] ?? type.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: _getTypeColor(type),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar los Pokémon',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Forzar la reconstrucción del FutureBuilder
                      setState(() {});
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    final Map<String, Color> typeColors = {
      'normal': Colors.grey[400]!,
      'fighting': Colors.red[700]!,
      'flying': Colors.indigo[200]!,
      'poison': Colors.purple[700]!,
      'ground': Colors.brown[400]!,
      'rock': Colors.brown[700]!,
      'bug': Colors.lightGreen[700]!,
      'ghost': Colors.purple[900]!,
      'steel': Colors.blueGrey[600]!,
      'fire': Colors.orange[700]!,
      'water': Colors.blue[700]!,
      'grass': Colors.green[600]!,
      'electric': Colors.amber[600]!,
      'psychic': Colors.pink[400]!,
      'ice': Colors.lightBlue[400]!,
      'dragon': Colors.indigo[700]!,
      'dark': Colors.grey[800]!,
      'fairy': Colors.pink[300]!,
    };

    return typeColors[type] ?? Colors.grey;
  }
  
  void setState(Null Function() param0) {}
}