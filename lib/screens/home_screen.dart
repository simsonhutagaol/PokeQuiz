import 'package:flutter/material.dart';
import 'package:pokemon_quiz/screens/guess_name_pokemon_screen.dart';
import 'package:pokemon_quiz/screens/guess_weight_pokemon_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final buttonWidth =
        isMobile ? screenSize.width * 0.8 : screenSize.width * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokémon Quiz',
          style: TextStyle(
            fontSize: 30,
            wordSpacing: 5,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(237, 218, 24, 10),
          ),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_pokemon1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context,
                  'Guess Pokémon Name',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GuessPokemonNameScreen(),
                      ),
                    );
                  },
                  buttonWidth,
                ),
                const SizedBox(height: 30),
                _buildButton(
                  context,
                  'Guess Pokémon Weight',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GuessPokemonWeightScreen(),
                      ),
                    );
                  },
                  buttonWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed, double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.amberAccent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 7),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
