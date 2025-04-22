import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  // Getters
  User? get currentUser => _currentUser;
  int? get userId => _currentUser?.id;
  String? get userName => _currentUser?.nombre;
  String? get userEmail => _currentUser?.email;
  bool get isLoggedIn => _currentUser != null;

  // Establecer el usuario logueado
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Actualizar datos del usuario
  void updateUser(User updatedUser) {
    if (_currentUser != null && _currentUser!.id == updatedUser.id) {
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  // Cerrar sesión
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
