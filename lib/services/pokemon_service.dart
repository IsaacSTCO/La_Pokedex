import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../models/pokemon.dart';
import '../models/pokemon_type.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const int pageSize = 20;

  static Map<int, List<int>> generationRanges = {
    1: [1, 151], // Gen 1
    2: [152, 251], // Gen 2
    3: [252, 386], // Gen 3
    4: [387, 493], // Gen 4
    5: [494, 649], // Gen 5
    6: [650, 721], // Gen 6
    7: [722, 809], // Gen 7
    8: [810, 898], // Gen 8
    9: [899, 1010], // Gen 9
  };

  Future<List<String>> getTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((type) => type['name'] as String)
          .where((type) => PokemonType.typeNames.containsKey(type))
          .toList();
    }
    return [];
  }

  Future<List<Pokemon>> getPokemonByGeneration(int generation) async {
    final range = generationRanges[generation]!;
    List<Pokemon> pokemons = [];

    for (int i = range[0]; i <= range[1]; i++) {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/$i'));
      if (response.statusCode == 200) {
        pokemons.add(Pokemon.fromJson(json.decode(response.body)));
      }
    }
    return pokemons;
  }

  Future<Map<String, dynamic>> getPokemonByType(String type, int page) async {
    final response = await http.get(Uri.parse('$baseUrl/type/$type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final allPokemon = data['pokemon'] as List;
      final totalCount = allPokemon.length;

      final start = page * pageSize;
      final end = min(start + pageSize, totalCount);
      final pageItems = allPokemon.sublist(start, end);

      List<Pokemon> pokemons = [];
      for (var pokemon in pageItems) {
        final pokemonResponse = await http.get(
          Uri.parse(pokemon['pokemon']['url']),
        );
        if (pokemonResponse.statusCode == 200) {
          pokemons.add(Pokemon.fromJson(json.decode(pokemonResponse.body)));
        }
      }

      return {
        'pokemons': pokemons,
        'totalCount': totalCount,
        'hasMore': end < totalCount,
      };
    }
    return {
      'pokemons': <Pokemon>[],
      'totalCount': 0,
      'hasMore': false,
    };
  }

  Future<Pokemon?> getPokemonById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
      if (response.statusCode == 200) {
        return Pokemon.fromJson(json.decode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching pokemon $id: $e');
      }
    }
    return null;
  }

  Future<int> getPokemonCountByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/type/$type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['pokemon'] as List).length;
    }
    return 0; // Devuelve 0 si ocurre un error
  }
}
