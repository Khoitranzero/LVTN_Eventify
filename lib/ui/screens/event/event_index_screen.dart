import 'package:flutter/material.dart';
import 'package:Eventify/ui/component/molcules/UIEventTabBar.dart';

class EventIndexScreen extends StatelessWidget {

  const EventIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: UIEventTabBarScreen()),
    );
  }
}
