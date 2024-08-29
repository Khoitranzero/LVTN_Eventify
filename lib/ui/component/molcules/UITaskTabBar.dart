import 'package:Eventify/ui/screens/task/completed_taskList_screen.dart';
import 'package:Eventify/ui/screens/task/unCompleted_taskList_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UITaskTabBarScreen extends StatefulWidget {
  const UITaskTabBarScreen({super.key});

  @override
  State<UITaskTabBarScreen> createState() => _UITaskTabBarScreenState();
}
class _UITaskTabBarScreenState extends State<UITaskTabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _unselectedColor = Colors.white;
  final _tabs = const [
    Tab(text: 'Chưa hoàn thành'),
    Tab(text: 'Hoàn thành'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách công việc"),
        backgroundColor: Theme.of(context).primaryColor,
         leading: IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              context.pushReplacement('/index');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: _selectedColor,
          indicatorColor: _selectedColor,
          unselectedLabelColor: _unselectedColor,
          labelStyle: const TextStyle(fontSize: 20),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UnCompletedTaskListScreen(),
          CompletedTaskListScreen(),
        ],
      ),
    );
  }
}
