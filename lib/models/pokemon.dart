class Pokemon {
  final String name;
  final String imageUrl;
  final int weight;
  final String type;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.type,
  });

  factory Pokemon.fromJsonForWeight(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      weight: json['weight'],
      type: '',
    );
  }

  factory Pokemon.fromJsonForName(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      weight: 0,
      type: json['types'].isNotEmpty ? json['types'][0]['type']['name'] : '',
    );
  }

  String get displayName => name.toUpperCase();

  String get displayWeight => 'Weight: ${weight / 10} kg';
}
