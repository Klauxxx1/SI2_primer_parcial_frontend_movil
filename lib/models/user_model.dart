class User {
  final int? id; // O puede ser String dependiendo de tu backend
  final String? nombre;
  final String? email;
  // Otros campos...

  User({
    this.id,
    this.nombre,
    this.email,
    // Otros campos...
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Esto podría ser json['id'] o json['user_id'] dependiendo de tu API
      nombre: json['nombre'],
      email: json['email'],
      // Otros campos...
    );
  }
}
