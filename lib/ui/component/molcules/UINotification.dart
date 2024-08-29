import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String notifyId;
  final String type;
  final bool isRead;
  final DateTime createAt;
  final String data;
  final String eventId;
  final String userId;

  NotificationItem({
    required this.notifyId,
    required this.type,
    required this.isRead,
    required this.createAt,
    required this.data,
    required this.eventId,
    required this.userId,
  });

   factory NotificationItem.fromJson(Map<String, dynamic> json) {
    // print("json là : ${json}");
    return NotificationItem(
     notifyId: json['id'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
     createAt: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createAt']),
      data: json['data'] ?? '',
      eventId: json['eventId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}


class UINotificationItem extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback markAsReadCallback;
  final VoidCallback deleteCallback;
  

  UINotificationItem({
    required this.notification,
    required this.onTap,
    required this.markAsReadCallback,
    required this.deleteCallback, 
  });

  @override
  Widget build(BuildContext context) {
    Widget _buildTypeWidget(String type) {
      if (type.contains('create')) {
        if (type.contains('task')) {
          return Row(
            children: [
              Icon(Icons.fiber_new, color: Colors.green),
              SizedBox(width: 4),
              Text('Tạo mới công việc'),
            ],
          );
        } else if (type.contains('event')) {
          return Row(
            children: [
              Icon(Icons.fiber_new, color: Colors.green),
              SizedBox(width: 4),
              Text('Tạo mới sự kiện'),
            ],
          );
        } else if (type.contains('cost')) {
          return Row(
            children: [
              Icon(Icons.fiber_new, color: Colors.green),
              SizedBox(width: 4),
              Text('Thêm chi phí'),
            ],
          );
        } else if (type.contains('user')) {
          return Row(
            children: [
              Icon(Icons.fiber_new, color: Colors.green),
              SizedBox(width: 4),
              Text('Thêm thành viên'),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.fiber_new, color: Colors.green),
              SizedBox(width: 4),
              Text('Tạo mới'),
            ],
          );
        }
      } else if (type.contains('update')) {
        if (type.contains('task')) {
          return Row(
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue),
              SizedBox(width: 4),
              Text('Cập nhật công việc'),
            ],
          );
        } else if (type.contains('event')) {
          return Row(
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue),
              SizedBox(width: 4),
              Text('Cập nhật sự kiện'),
            ],
          );
        } else if (type.contains('cost')) {
          return Row(
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue),
              SizedBox(width: 4),
              Text('Cập nhật chi phí'),
            ],
          );
        } else if (type.contains('user')) {
          return Row(
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue),
              SizedBox(width: 4),
              Text('Cập nhật thành viên'),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue),
              SizedBox(width: 4),
              Text('Cập nhật'),
            ],
          );
        }
      } else if (type.contains('delete')) {
        if (type.contains('task')) {
          return Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 4),
              Text('Xóa công việc'),
            ],
          );
        } else if (type.contains('event')) {
          return Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 4),
              Text('Xóa sự kiện'),
            ],
          );
        } else if (type.contains('cost')) {
          return Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 4),
              Text('Xóa chi phí'),
            ],
          );
        } else if (type.contains('user')) {
          return Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 4),
              Text('Xóa thành viên'),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 4),
              Text('Xóa'),
            ],
          );
        }
      } else if (type.contains('event')) {
        return Text('Sự kiện');
      } else if (type.contains('task')) {
        return Text('Công việc');
      } else if (type.contains('cost')) {
        return Text('Chi phí');
      } else if (type.contains('user')) {
        return Text('Thành viên');
      } else {
        return Text(type);
      }
    }

String _formatDate(DateTime dateTime) {
  DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
  return formatter.format(dateTime);
}

    // String _formatDate(String dateStr) {
    //   DateTime dateTime = DateTime.parse(dateStr);
    //   DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    //   return formatter.format(dateTime);
    // }

    void _showBottomModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text('Đánh dấu đã đọc'),
                onTap: markAsReadCallback, // Sửa đoạn này
              ),

                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Xóa thông báo'),
                  onTap: deleteCallback,
                ),
              ListTile(
                leading: Icon(Icons.cancel_presentation),
                  title: Text('Hủy'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ),
          );
        },
      );
    }

   return GestureDetector(
  onTap: onTap,
  child: Container(
    width: double.infinity,
    padding: EdgeInsets.all(8.0),
    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: _buildTypeWidget(notification.type),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomModal(context);
                        },
                        child: Icon(Icons.more_horiz, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: notification.isRead ? Colors.transparent : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), 
          Text(_formatDate(notification.createAt), style: TextStyle(fontSize: 15)),
          SizedBox(height: 8.0), 
          Text(
            '${notification.data}',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    ),
  ),
);
 }
}

