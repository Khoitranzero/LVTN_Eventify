import 'package:Eventify/ui/component/molcules/UITaskDetailTabBar.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {

  const TaskDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: UITaskDetailTabBarScreen(),
      ),
    );
  }
}
