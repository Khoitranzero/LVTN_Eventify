import 'package:Eventify/ui/screens/task/member_in_task_screen.dart';
import 'package:Eventify/ui/screens/task/task_detail_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UITaskDetailTabBarScreen extends StatefulWidget {

  const UITaskDetailTabBarScreen({super.key});

  @override
  State<UITaskDetailTabBarScreen> createState() => _UITaskDetailTabBarScreenState();
}
class _UITaskDetailTabBarScreenState extends State<UITaskDetailTabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _unselectedColor = Colors.white;
  final _labelColor = Colors.white;
  final _tabs = const [
    Tab(text: 'Công việc'),
    Tab(text: 'Thành viên'),
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
        title: const Text("Chi tiết nhiệm vụ"),
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
            }  
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: _labelColor,
          labelStyle: const TextStyle(fontSize: 13),
          indicatorColor: Theme.of(context).primaryColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskDetailTabScreen(),
          TaskMemberScreen(),
        ],
      ),

    );
  }
}
