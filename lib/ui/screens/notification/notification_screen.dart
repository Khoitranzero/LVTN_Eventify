import 'dart:convert';

import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/molcules/UINotification.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:Eventify/ui/screens/notification/NotificationWebSocket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RouterService routerService = RouterService();
  NotificationWebSocket? webSocket;
  NotificationRepository notificationRepository = NotificationRepository();
  List<NotificationItem> notificationItems = [];
  bool isLoading = true;


    @override
  void initState() {
    super.initState();
    fetchUserNotification();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Khởi tạo một đối tượng WebSocket để kết nối với máy chủ
    webSocket = NotificationWebSocket(
      'ws://${ApiConfig.ipv4}:8080/notifications?userId=${authProvider.id}',
      (message) {
        // Giải mã dữ liệu JSON từ thông báo nhận được để lấy danh sách thông báo.
        final List<dynamic> dataList = jsonDecode(message)['DT'];
        setState(() {
          for (var data in dataList) {
            NotificationItem newItem = NotificationItem.fromJson(data);
            if (newItem.userId == authProvider.id &&
                !notificationItems.any((item) => item.notifyId == newItem.notifyId)) {
              notificationItems.add(newItem);
            }
          }
          notificationItems.sort((a, b) => b.createAt.compareTo(a.createAt));
        });
      },
    );
  }
 @override
  void dispose() {
    webSocket?.close();//để đóng kết nối WebSocket và giải phóng tài nguyên.
    super.dispose();
  }

  
  Future<void> fetchUserNotification() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await notificationRepository.getAllUserNotification(authProvider.id);
      if (response['EC'] == 0) {
        setState(() {
          notificationItems = (response['DT'] as List).map((notification) {
            return NotificationItem.fromJson(notification);
          }).toList();
          notificationItems.sort((a, b) => b.createAt.compareTo(a.createAt));
          isLoading = false;
        });
      } else {
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }


  Future<void> readAllNotify() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  try {
    final response = await notificationRepository.readAllNotify(authProvider.id);
    if (response['EC'] == 0) {
      if (mounted) {
        setState(() {

          fetchUserNotification();
          // Navigator.pop(context);
        });
      }
    } else {
      UIToastNN.showToastError(response['EM']);
      print(response['EM']);
    }
  } catch (e) {
    print("Error fetching notifications: $e");
  }
}



  Future<void> readOneNotify(String notifyId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response =
          await notificationRepository.readOneNotify(notifyId, authProvider.id);
      if (response['EC'] == 0) {
        fetchUserNotification();
         Navigator.pop(context);
      } else {
        UIToastNN.showToastError(response['EM']);
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  Future<void> deleteNotify(String notifyId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response =
          await notificationRepository.deleteNotify(authProvider.id, notifyId);
      if (response['EC'] == 0) {
         fetchUserNotification();
         Navigator.pop(context);
      } else {
        UIToastNN.showToastError(response['EM']);
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void navigateToNotifyDetail(String eventId) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //      builder: (context) => EventIndexScreen(eventId: eventId),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Thông báo"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      readAllNotify();
                    },
                    child: Text(
                      "Đọc tất cả",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notificationItems.length,
                    itemBuilder: (context, index) {
                      return UINotificationItem(
                        notification: notificationItems[index],
                        onTap: () => navigateToNotifyDetail(
                            notificationItems[index].eventId),
                        markAsReadCallback: () =>
                            readOneNotify(notificationItems[index].notifyId),
                        deleteCallback: () =>
                            deleteNotify(notificationItems[index].notifyId),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
