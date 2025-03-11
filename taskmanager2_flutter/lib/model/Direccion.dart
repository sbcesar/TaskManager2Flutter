class Direccion {
  final String provincia;
  final String municipio;

  Direccion({
    required this.provincia,
    required this.municipio,
  });

  Map<String, dynamic> toJson() {
    return {
      "provincia": provincia,
      "municipio": municipio,
    };
  }

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      provincia: json['provincia'],
      municipio: json['municipio'],
    );
  }
}