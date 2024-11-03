// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../models/pokemon_type.dart';

class PokemonTypeListScreen extends StatefulWidget {
  final String type;

  static final Map<String, Color> _coloresTipos = {
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

  const PokemonTypeListScreen({super.key, required this.type});

  @override
  _PokemonTypeListScreenState createState() => _PokemonTypeListScreenState();
}

class _PokemonTypeListScreenState extends State<PokemonTypeListScreen> {
  final PokemonService _service = PokemonService();
  final List<Pokemon> _pokemons = [];
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final result = await _service.getPokemonByType(widget.type, _currentPage);
    
    setState(() {
      _pokemons.addAll(result['pokemons'] as List<Pokemon>);
      _hasMore = result['hasMore'] as bool;
      _totalCount = result['totalCount'] as int;
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${PokemonType.typeNames[widget.type]} (${_pokemons.length}/$_totalCount)'),
        backgroundColor: PokemonTypeListScreen._coloresTipos[widget.type],
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading && _hasMore && 
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _loadMore();
                }
                return true;
              },
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                ),
                itemCount: _pokemons.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _pokemons.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final pokemon = _pokemons[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          pokemon.imageUrl,
                          height: 100,
                        ),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Espaciado entre tipos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: pokemon.types
                              .map((type) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0), // Espaciado horizontal
                                    child: Chip(
                                      label: Text(
                                        PokemonType.typeNames[type] ?? type.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: PokemonTypeListScreen._coloresTipos[type] ?? Colors.grey,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}