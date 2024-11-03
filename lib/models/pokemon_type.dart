class PokemonType {
  final String name;
  final String imageUrl;

  PokemonType({required this.name, required this.imageUrl});

  // Mapa de tipos a nombres en español
  static Map<String, String> typeNames = {
    'normal': 'Normal',
    'fighting': 'Lucha',
    'flying': 'Volador',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'rock': 'Roca',
    'bug': 'Bicho',
    'ghost': 'Fantasma',
    'steel': 'Acero',
    'fire': 'Fuego',
    'water': 'Agua',
    'grass': 'Planta',
    'electric': 'Eléctrico',
    'psychic': 'Psíquico',
    'ice': 'Hielo',
    'dragon': 'Dragón',
    'dark': 'Siniestro',
    'fairy': 'Hada',
  };

  // Mapa de tipos a URLs de imágenes
  static Map<String, String> typeImages = {
    'normal': 'assets/types/normals.png',
    'fighting': 'assets/types/lucha.png',
    'flying': 'assets/types/volador.png',
    'poison': 'assets/types/veneno.png',
    'ground': 'assets/types/tierra.png',
    'rock': 'assets/types/roca.png',
    'bug': 'assets/types/bicho.png',
    'ghost': 'assets/types/fantasma.png',
    'steel': 'assets/types/acero.png',
    'fire': 'assets/types/fuego.png',
    'water': 'assets/types/agua.png',
    'grass': 'assets/types/planta.png',
    'electric': 'assets/types/electrico.png',
    'psychic': 'assets/types/psiquico.png',
    'ice': 'assets/types/hielo.png',
    'dragon': 'assets/types/dragon.png',
    'dark': 'assets/types/siniestro.png',
    'fairy': 'assets/types/hada.png',
  };
}