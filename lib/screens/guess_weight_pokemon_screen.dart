import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemon_quiz/models/pokemon.dart';
import 'package:pokemon_quiz/services/pokemon_service.dart';

class GuessPokemonWeightScreen extends StatefulWidget {
  @override
  _GuessPokemonWeightState createState() => _GuessPokemonWeightState();
}

class _GuessPokemonWeightState extends State<GuessPokemonWeightScreen> {
  Future<List<Pokemon>>? _pokemonOptions;
  bool _isLoading = true;
  String _message = '';
  bool _showWeight = false;
  Pokemon? selectedPokemon;
  Pokemon? correctPokemon;
  int correctGuesses = 0;
  int attempts = 0;
  bool _showFinalResult = false;

  @override
  void initState() {
    super.initState();
    _loadPokemonOptions();
  }

  void _loadPokemonOptions() {
    setState(() {
      _isLoading = true;
      _message = '';
      _showWeight = false;
      selectedPokemon = null;
      _showFinalResult = false;
    });
    _pokemonOptions = fetchTwoPokemonOptions();
    _pokemonOptions!.whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<List<Pokemon>> fetchTwoPokemonOptions() async {
    final List<Pokemon> options = [];
    options.add(await fetchRandomPokemonForWeight());
    options.add(await fetchRandomPokemonForWeight());
    return options;
  }

  void _checkAnswer(Pokemon selected, Pokemon other) {
    setState(() {
      _showWeight = true;
      selectedPokemon = selected;
      correctPokemon = (selected.weight >= other.weight) ? selected : other;
      if (selected.weight >= other.weight) {
        correctGuesses++;
        _message = 'Correct! ${selected.name} is heavier.';
      } else {
        _message = 'Wrong! ${other.name} is heavier.';
      }
      attempts++;
    });

    if (attempts == 6) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showFinalResult = true;
        });
      });
    }
  }

  Widget _buildPokemonButton(
      Pokemon pokemon, Pokemon otherPokemon, double imageSize) {
    return GestureDetector(
      onTap: _showWeight ? null : () => _checkAnswer(pokemon, otherPokemon),
      child: Column(
        children: [
          if (_showWeight)
            Text(
              '${pokemon.weight} kg',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 5),
          Image.network(
            pokemon.imageUrl,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 5),
          Text(
            pokemon.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.width * 0.3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Guess Pokémon Weight',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showFinalResult
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Final Score: $correctGuesses / 6',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          correctGuesses = 0;
                          attempts = 0;
                          _loadPokemonOptions();
                        });
                      },
                      child: const Text('Play Again',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Text(
                    'Score: $correctGuesses / $attempts',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    Expanded(
                      child: Image.asset(
                        "assets/pokemon2.gif",
                      ),
                    )
                  else
                    Expanded(
                      child: FutureBuilder<List<Pokemon>>(
                        future: _pokemonOptions,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final List<Pokemon> pokemonList = snapshot.data!;
                            final Pokemon pokemon1 = pokemonList[0];
                            final Pokemon pokemon2 = pokemonList[1];

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildPokemonButton(
                                          pokemon1, pokemon2, imageSize),
                                      _buildPokemonButton(
                                          pokemon2, pokemon1, imageSize),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  if (_showWeight)
                                    Text(
                                      _message,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _message.contains('Correct')
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  if (attempts < 6)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPokemon == null
                                ? Colors.grey
                                : Colors.redAccent),
                        onPressed: selectedPokemon == null
                            ? null
                            : _loadPokemonOptions,
                        child: const Text('Next Pokémon',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
