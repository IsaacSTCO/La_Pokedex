import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/pokemon_type.dart';
import '../services/pokemon_service.dart';

class PokemonGenerationListScreen extends StatefulWidget {
  final int generation;

  const PokemonGenerationListScreen({super.key, 
    required this.generation,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PokemonGenerationListScreenState createState() => _PokemonGenerationListScreenState();
}

class _PokemonGenerationListScreenState extends State<PokemonGenerationListScreen> {
  final PokemonService _pokeApi = PokemonService();
  final List<Pokemon> _misPokemon = [];
  final ScrollController _scrollControl = ScrollController();
  
  int _paginaActual = 0;
  bool _estaCargando = false;
  bool _hayMas = true;
  int _totalPokemon = 0;

  // Puedes personalizar los colores de los tipos de Pokémon
  final Map<String, Color> _coloresTipos = {
    'normal': Color(0xFFAAA67F),
    'fighting': Color(0xFFC12239),
    'flying': Color(0xFFA891EC),
    'poison': Color(0xFFA43E9E),
    'ground': Color(0xFFDEC16B),
    'rock': Color(0xFFB69E31),
    'bug': Color(0xFFA7B723),
    'ghost': Color(0xFF70559B),
    'steel': Color(0xFFB7B9D0),
    'fire': Color(0xFFF57D31),
    'water': Color(0xFF6493EB),
    'grass': Color(0xFF74CB48),
    'electric': Color(0xFFF9CF30),
    'psychic': Color(0xFFFB5584),
    'ice': Color(0xFF9AD6DF),
    'dragon': Color(0xFF7037FF),
    'dark': Color(0xFF75574C),
    'fairy': Color(0xFFE69EAC),
  };

  @override
  void initState() {
    super.initState();
    _cargarMasPokemon();
    _scrollControl.addListener(_cuandoScrollea);
    
    final rango = PokemonService.generationRanges[widget.generation]!;
    _totalPokemon = rango[1] - rango[0] + 1;
  }

  @override
  void dispose() {
    _scrollControl.dispose();
    super.dispose();
  }

  // Esta función se llama cuando el usuario scrollea hacia abajo
  void _cuandoScrollea() {
    if (_scrollControl.position.pixels >= 
        _scrollControl.position.maxScrollExtent - 200) {
      _cargarMasPokemon();
    }
  }

  // Aquí cargamos más Pokémon cuando se necesitan
  Future<void> _cargarMasPokemon() async {
    if (_estaCargando || !_hayMas) return;

    setState(() => _estaCargando = true);

    final rango = PokemonService.generationRanges[widget.generation]!;
    final inicio = rango[0] + (_paginaActual * 20);
    final fin = rango[0] + (_paginaActual * 20) + 19;
    
    if (inicio > rango[1]) {
      setState(() {
        _hayMas = false;
        _estaCargando = false;
      });
      return;
    }

    List<Pokemon> nuevosPokemon = [];
    for (int i = inicio; i <= fin && i <= rango[1]; i++) {
      try {
        final pokemon = await _pokeApi.getPokemonById(i);
        if (pokemon != null) {
          nuevosPokemon.add(pokemon);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Ups, error cargando el pokemon $i: $e');
        }
      }
    }

    setState(() {
      _misPokemon.addAll(nuevosPokemon);
      _paginaActual++;
      _estaCargando = false;
      _hayMas = inicio + 20 <= rango[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Puedes cambiar los nombres de las regiones aquí también
    final nombresRegiones = {
      1: '🌿 Kanto',
      2: '🍃 Johto',
      3: '🌺 Hoenn',
      4: '❄️ Sinnoh',
      5: '🌆 Unova',
      6: '🌸 Kalos',
      7: '🏖️ Alola',
      8: '☁️ Galar',
      9: '🎓 Paldea',
    };

    return Scaffold(
      // Puedes personalizar el color del AppBar
      appBar: AppBar(
        backgroundColor: Colors.red[700],  // Cámbialo al color que quieras
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generación ${widget.generation}'),
            Text(
              '${nombresRegiones[widget.generation]} (${_misPokemon.length}/$_totalPokemon)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      // Puedes cambiar el color de fondo de la pantalla
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollControl,
              padding: EdgeInsets.all(8),
              // Personaliza cómo se ven las tarjetas de Pokémon
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,  // Cambia esto para más o menos columnas
                childAspectRatio: 0.75,  // Ajusta el tamaño de las tarjetas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _misPokemon.length + (_hayMas ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _misPokemon.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final pokemon = _misPokemon[index];
                // Aquí puedes personalizar cómo se ve cada tarjeta de Pokémon
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Imagen del Pokémon
                      SizedBox(
                        height: 120,
                        child: Image.network(
                          pokemon.imageUrl,
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
                            return Icon(Icons.catching_pokemon, size: 80);
                          },
                        ),
                      ),
                      // Número del Pokémon
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Nombre del Pokémon
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          pokemon.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Tipos del Pokémon
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        children: pokemon.types.map((tipo) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _coloresTipos[tipo] ?? Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            PokemonType.typeNames[tipo] ?? tipo.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_estaCargando)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}