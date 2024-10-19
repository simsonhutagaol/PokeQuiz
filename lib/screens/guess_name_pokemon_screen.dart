import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokemon_quiz/models/pokemon.dart';
import 'package:pokemon_quiz/services/pokemon_service.dart';

class GuessPokemonNameScreen extends StatefulWidget {
  @override
  _GuessPokemonNameScreenState createState() => _GuessPokemonNameScreenState();
}

class _GuessPokemonNameScreenState extends State<GuessPokemonNameScreen> {
  late Future<List<Pokemon>> _pokemonOptions;
  List<Pokemon>? pokemonList;
  bool _isLoading = true;
  String _message = '';
  bool _isCorrect = false;
  Pokemon? correctPokemon;
  String? selectedPokemonName;
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
      _isCorrect = false;
      selectedPokemonName = null;
      _showFinalResult = false;
    });
    _pokemonOptions = fetchTwoPokemonOptions();
    _pokemonOptions.whenComplete(() {
      setState(() {
        _isLoading = false;
        pokemonList = null;
      });
    });
  }

  Future<List<Pokemon>> fetchTwoPokemonOptions() async {
    return [
      await fetchRandomPokemonForName(),
      await fetchRandomPokemonForName(),
    ];
  }

  void _checkAnswer(Pokemon selectedPokemon) {
    setState(() {
      selectedPokemonName = selectedPokemon.name;
      if (selectedPokemon.name == correctPokemon!.name) {
        _isCorrect = true;
        correctGuesses++;
        _message = 'Correct! It is ${correctPokemon!.name}.';
      } else {
        _isCorrect = false;
        _message = 'Wrong! It is ${correctPokemon!.name}.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Guess Pokémon Name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = constraints.maxWidth;
          final imageSize = screenSize * 0.5;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _showFinalResult
                ? _buildFinalResult()
                : _buildGameContent(imageSize),
          );
        },
      ),
    );
  }

  Widget _buildFinalResult() {
    return Center(
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              setState(() {
                correctGuesses = 0;
                attempts = 0;
                pokemonList = null;
                _loadPokemonOptions();
              });
            },
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(double imageSize) {
    return Column(
      children: [
        Text(
          'Score: $correctGuesses / $attempts',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (_isLoading)
          Expanded(
            child: Image.asset("assets/pokemon2.gif"),
          )
        else
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: _pokemonOptions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  if (pokemonList == null) {
                    pokemonList = snapshot.data!;
                    pokemonList!.shuffle();
                    correctPokemon =
                        pokemonList![Random().nextInt(pokemonList!.length)];
                  }

                  return _buildPokemonOptions(imageSize);
                }
                return Container();
              },
            ),
          ),
        if (attempts < 6) _buildNextButton(),
      ],
    );
  }

  Widget _buildPokemonOptions(double imageSize) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            correctPokemon!.imageUrl,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          for (var pokemon in pokemonList!) _buildPokemonButton(pokemon),
          const SizedBox(height: 20),
          Text(
            _message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isCorrect ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonButton(Pokemon pokemon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selectedPokemonName == pokemon.name
            ? (_isCorrect ? Colors.green : Colors.red)
            : Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 5),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: const TextStyle(fontSize: 24),
        ),
        onPressed: selectedPokemonName == null
            ? () {
                _checkAnswer(pokemon);
              }
            : null,
        child: Text(
          pokemon.name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedPokemonName == null ? Colors.grey : Colors.redAccent,
        ),
        onPressed: selectedPokemonName == null ? null : _loadPokemonOptions,
        child: const Text('Next Pokémon',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}
