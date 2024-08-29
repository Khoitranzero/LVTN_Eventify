import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIResponsiveNavBarPage.dart';
import 'package:Eventify/ui/screens/event/costs_Tab/event_costs_screen.dart';
import 'package:flutter/material.dart';
import 'package:Eventify/ui/screens/event/detail_Tab/event_infor_screen.dart';
import 'package:Eventify/ui/screens/event/member_Tab/event_member_screen.dart';
import 'package:Eventify/ui/screens/event/timeline_Tab/event_timeline_screen.dart';


class UIEventTabBarScreen extends StatefulWidget {
  const UIEventTabBarScreen({super.key});

  @override
  State<UIEventTabBarScreen> createState() => _UIEventTabBarScreenState();
}

class _UIEventTabBarScreenState extends State<UIEventTabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _unselectedColor = Colors.white;
  final _labelColor = Colors.white;
  final _tabs = const [
    Tab(text: 'Thông tin'),
    Tab(text: 'Timeline'),
    Tab(text: 'Thành viên'),
    Tab(text: 'Chi phí'),
  ];
  final RouterService routerService = RouterService();
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  void openDrawer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ResponsiveNavBarPage(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
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
        title: const Text("Chi tiết sự kiện"),
        leading: IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
       
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
          EventInforScreen(),
          EventTimelineScreen(),
          EventMemberScreen(),
          EventCostScreen(),
        ],
      ),
    );
  }
}
