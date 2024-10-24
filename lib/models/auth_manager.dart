import 'package:local_auth/local_auth.dart';
import 'package:secure_notes/services/auth_service.dart';

class AuthManager {
  // Singleton instance
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isBiometricsAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isBiometricsAvailable => _isBiometricsAvailable;
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  Future<void> checkBiometrics() async {
    _isBiometricsAvailable = await _authService.isBiometricsAvailable();
    if (_isBiometricsAvailable) {
      _availableBiometrics = await _authService.getAvailableBiometrics();
    }
  }

  Future<bool> authenticate() async {
    if (!_isBiometricsAvailable) return false;
    _isAuthenticated = await _authService.authenticateUser();
    return _isAuthenticated;
  }

  void logout() {
    _isAuthenticated = false;
  }
}
