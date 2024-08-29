import 'package:Eventify/ui/component/molcules/UITaskTabBar.dart';
import 'package:flutter/material.dart';

class TaskIndexScreen extends StatelessWidget {

  const TaskIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: UITaskTabBarScreen()),
    );
  }
}
