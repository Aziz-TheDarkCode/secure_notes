import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:secure_notes/models/auth_manager.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;
  final String title;

  const AuthWrapper({
    super.key,
    required this.child,
    this.title = 'Secure Notes',
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthManager _authManager = AuthManager();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      setState(() => _isLoading = true);
      await _authManager.checkBiometrics();

      if (!_authManager.isBiometricsAvailable) {
        setState(() {
          _errorMessage =
              'Biometric authentication is not available on this device';
        });
      } else if (_authManager.availableBiometrics.isEmpty) {
        setState(() {
          _errorMessage = 'No biometric methods are enrolled on this device';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to check biometric availability: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _authenticate() async {
    if (!_authManager.isBiometricsAvailable) {
      setState(
          () => _errorMessage = 'Biometric authentication is not available');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final authenticated = await _authManager.authenticate();

      if (!authenticated) {
        setState(
            () => _errorMessage = 'Authentication failed. Please try again.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Authentication error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_authManager.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => setState(() {
                _authManager.logout();
                _errorMessage = '';
              }),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _authManager.isAuthenticated
                    ? widget.child
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              iconSize: 48,
                              onPressed: _isLoading ? null : _authenticate,
                              icon: Icon(
                                _authManager.availableBiometrics
                                        .contains(BiometricType.face)
                                    ? LucideIcons.scanFace
                                    : LucideIcons.fingerprint,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Please authenticate to access the app',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
