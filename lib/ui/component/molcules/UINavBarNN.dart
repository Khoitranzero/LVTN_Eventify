import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/notifycation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/ui/screens/chat/chat_screen.dart';
import 'package:Eventify/ui/screens/home/home_screen.dart';
import 'package:Eventify/ui/screens/notification/notification_screen.dart';
import 'package:Eventify/ui/screens/user/user_info_screen.dart';


class UiNavbarNN extends StatefulWidget {
  const UiNavbarNN({Key? key}) : super(key: key);

  @override
  State<UiNavbarNN> createState() => _UiNavbarNNState();
}

class _UiNavbarNNState extends State<UiNavbarNN> {
  int _selectedIndex = 0;
  final List<bool> _shouldRender = [true, false, false, false];
  bool _hasNewNotifications = false; // Biến trạng thái thông báo mới
  late NotificationService _notificationService;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatScreen(),
    const NotificationScreen(),
    const UserInfoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _notificationService = NotificationService(
      'ws://${ApiConfig.ipv4}:8080/notifications?userId=${authProvider.id}',
      (hasNewNotifications) {
        setState(() {
          _hasNewNotifications = hasNewNotifications;
        });
      },
    );
  }

  @override
  void dispose() {
    _notificationService.close();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      for (int i = 0; i < _shouldRender.length; i++) {
        _shouldRender[i] = i == index;
      }
      _selectedIndex = index;
      if (index == 2) {
        _hasNewNotifications = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_screens.length, (index) {
          return _shouldRender[index] ? _screens[index] : Container();
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color(0xff757575),
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: List.generate(_navBarItems.length, (index) {
          final item = _navBarItems[index];
          if (index == 2) {
            return BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  item.icon,
                  if (_hasNewNotifications)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: item.activeIcon,
              label: item.label,
              backgroundColor: item.backgroundColor,
            );
          }
          return item;
        }),
      ),
    );
  }
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Trang chủ',
    backgroundColor: Colors.white
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.chat_outlined),
    activeIcon: Icon(Icons.chat),
    label: 'Trò chuyện',
    backgroundColor: Colors.white
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.notifications_outlined),
    activeIcon: Icon(Icons.notifications),
    label: 'Thông báo',
    backgroundColor: Colors.white
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Thông tin',
    backgroundColor: Colors.white
  ),
];
