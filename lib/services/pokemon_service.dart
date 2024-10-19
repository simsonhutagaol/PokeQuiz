import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

const int maxPokemonId = 898;

Future<Pokemon> fetchRandomPokemonForWeight() async {
  final randomId = Random().nextInt(maxPokemonId) + 1;
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomId'),
  );

  if (response.statusCode == 200) {
    return Pokemon.fromJsonForWeight(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to load Pokémon for weight feature: ${response.statusCode}');
  }
}

Future<Pokemon> fetchRandomPokemonForName() async {
  final randomId = Random().nextInt(maxPokemonId) + 1;
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomId'),
  );

  if (response.statusCode == 200) {
    return Pokemon.fromJsonForName(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to load Pokémon for name feature: ${response.statusCode}');
  }
}
