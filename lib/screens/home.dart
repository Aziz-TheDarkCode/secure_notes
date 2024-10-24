import 'package:flutter/material.dart';
import 'package:secure_notes/_widgets/auth/auth_wrapper.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthWrapper(title: "Secure Notes", child: Text("dsdd"));
  }
}
