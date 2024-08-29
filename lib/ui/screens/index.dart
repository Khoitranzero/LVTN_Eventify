import 'package:Eventify/ui/component/molcules/UINavBarNN.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!authProvider.isLoggedIn) {
        context.go('/login');
      }
    });

    return Scaffold(
       backgroundColor: Colors.white,
      bottomNavigationBar: const UiNavbarNN(),
    );
  }
}
