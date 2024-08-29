import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/component/molcules/UIMemberItem.dart';
import 'package:Eventify/ui/screens/event/member_Tab/add_memberToEvent_screen.dart';
import 'package:Eventify/ui/screens/event/member_Tab/choose_Leader_screen.dart';
import 'package:Eventify/ui/screens/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventMemberScreen extends StatefulWidget {


  const EventMemberScreen({Key? key}) : super(key: key);

  @override
  _EventMemberScreenState createState() => _EventMemberScreenState();
}

class _EventMemberScreenState extends State<EventMemberScreen> {
  final EventRepository eventRepository = EventRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<MemberItem> members = [];
  bool isLoading = true;
  String? userRole;


@override
  void initState() {
    super.initState();
    getUserRole();
    fetchAllMembers();
  }

  // @override
  // void dispose() {   
  //   super.dispose();
  // }

Future<void> _deleteMember(String userId, String role, String username) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final eventProvider = Provider.of<EventProvider>(context, listen: false);
  
  if (role == 'Leader' && authProvider.id == userId) {
    final response = await eventRepository.deleteUserInEvent(eventProvider.eventId, userId);
    if (response['EC'] == 0) {
      await _notificationRepository.createNotifycation(
        'deleteuser',
        "${authProvider.fullName}, đã rời khỏi sự kiện ${eventProvider.eventName}!",
        eventProvider.eventId,
        authProvider.id
      );
        // Navigator.of(context).pop();
      setState(() {
        // members.removeWhere((member) => member.userId == userId);
         Navigator.pop(context, true);
        // Navigator.pushReplacementNamed(context, '/index');
      });
    
    } else {
      print(response['EM']);
    }
  } else if (role != 'Leader' && authProvider.id == userId) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: "confirm",
          title: 'Xác nhận rời sự kiện',
          content: "Bạn có chắc chắn muốn rời sự kiện không?",
          confirmButtonText: 'Xác nhận',
          onConfirm: () async {
            final response = await eventRepository.deleteUserInEvent(eventProvider.eventId, userId);
            if (response['EC'] == 0) {
              await _notificationRepository.createNotifycation(
                'deleteuser',
                "${authProvider.fullName}, đã rời khỏi sự kiện ${eventProvider.eventName}!",
                eventProvider.eventId,
                authProvider.id
              );
                Navigator.of(context).pop();
            setState(() {
                members.removeWhere((member) => member.userId == userId);
                Navigator.pop(context, true);
                   });
            } else {
              print(response['EM']);
            }
          },
          cancelButtonText: 'Hủy',
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  } else {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: "delete",
          title: 'Xác nhận xóa',
          content: "Bạn có chắc chắn muốn ${authProvider.id == userId ? "rời sự kiện" : "xóa thành viên này"} không?",
          confirmButtonText: 'Xóa',
          onConfirm: () async {
            final response = await eventRepository.deleteUserInEvent(eventProvider.eventId, userId);
            if (response['EC'] == 0) {
              await _notificationRepository.createNotifycation(
                'deleteuser',
                "${authProvider.fullName}, đã xóa ${username} khỏi sự kiện ${eventProvider.eventName}!",
                eventProvider.eventId,
                authProvider.id
              );
              setState(() {
                members.removeWhere((member) => member.userId == userId);
              });
              Navigator.of(context).pop();
            } else {
              print(response['EM']);
            }
          },
          cancelButtonText: 'Hủy',
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

  Future<void> getUserRole() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await eventRepository.getUserRoleInEvent(
          eventProvider.eventId, authProvider.id);
      if (response['EC'] == 0) {
        userRole = response['DT']['role'];
      } else {
        print(response['EM']);
      }
    } catch (e) {
      ////do something
    }
  }

 Future<void> fetchAllMembers() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    try {
      final response = await eventRepository.getMemberInEvents(eventProvider.eventId);
      if (response['EC'] == 0) {
        final List<MemberItem> memberList = (response['DT'] as List).map((member) {
          return MemberItem(
            AvatarURL: member['avatarUrl'] ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
            name: member['name'],
            email: member['email'],
            role: member['role'],
            userId: member['id'],
          );
        }).toList();

        if (mounted) {
          setState(() {
            members = memberList;
            isLoading = false;
          });
        }
      } else {
        print(response['EM']);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching members: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateUserRole(String userId, String role, String username) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
     final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await eventRepository.updateUserRole(
          eventProvider.eventId, userId, role);
      if (response['EC'] == 0) {
         final notify = await _notificationRepository.createNotifycation(
          'updateuser', 
          "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã bổ nhiệm '${username}' làm '${role}' !",
          eventProvider.eventId, 
          authProvider.id);
        Navigator.pop(context,true);
     
        fetchAllMembers();
      }
    } catch (e) {
      print("Error fetching members: $e");
    }
  }

  void _showMemberInfoModal(MemberItem member) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isCurrentUser = authProvider.id == member.userId;

    showModalBottomSheet(
  context: context,
  builder: (context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: 9),
              CircleAvatar(
                backgroundImage: NetworkImage(member.AvatarURL),
              ),
              SizedBox(width: 8.0),
              Text(member.name, style: TextStyle(fontSize: 20)),
            ],
          ),
          ListTile(
            leading: Icon(Icons.person), // Thêm biểu tượng người dùng
            title: Text('Xem hồ sơ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(userId: member.userId),
                ),
              );
            },
          ),
          if (userRole == 'Leader') ...[
            if (isCurrentUser == false) ...[
              if (member.role == 'Deputy') ...[
                ListTile(
                  leading: Icon(Icons.group), // Thêm biểu tượng nhóm
                  title: Text('Chọn làm thành viên'),
                  onTap: () {
                    updateUserRole(member.userId, 'Member', member.name);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: Icon(Icons.supervisor_account), // Thêm biểu tượng phó sự kiện
                  title: Text('Chọn làm phó sự kiện'),
                  onTap: () {
                    updateUserRole(member.userId, 'Deputy', member.name);
                  },
                ),
              ],
            ],
            ListTile(
                leading: Icon(isCurrentUser ? Icons.exit_to_app : Icons.delete),
                title: Text(isCurrentUser ? 'Rời sự kiện' : 'Xóa thành viên'),
                onTap: () {
                  if (isCurrentUser) {
                    Navigator.pop(context); // Close the current bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.7, // Chiếm 70% chiều cao màn hình
                          child: DraggableScrollableSheet(
                            initialChildSize: 1.0, // Chiếm 100% chiều cao của FractionallySizedBox
                            minChildSize: 0.5, // Chiều cao nhỏ nhất là 50% của màn hình
                            maxChildSize: 1.0, // Chiều cao lớn nhất là 100% của màn hình
                            builder: (context, scrollController) {
                              return ChooseLeaderBottomModal(scrollController: scrollController);
                            },
                          ),
                        );
                      },
                    ).then((result) {
                       if (result == true) {
                        _deleteMember(member.userId, member.role, member.name);
                        // Navigator.pushReplacementNamed(context, '/index');
                      }
                    });
                  } else {
                    Navigator.of(context).pop();
                    _deleteMember(member.userId, member.role, member.name);
                  }
                },
              ),
          ],
          if (isCurrentUser && userRole != 'Leader') ...[
            ListTile(
              leading: Icon(Icons.exit_to_app), 
              title: Text('Rời sự kiện'),
              onTap: () async {
                Navigator.of(context).pop();
                
                await _deleteMember(member.userId, member.role, member.name);
                //  Navigator.pushReplacementNamed(context, '/index');
                // RouterService().goToIndexScreen(context);
                
              },
            ),
          ],
        ],
      ),
    );
  },
);
}

 Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách thành viên',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      UICustomButton(
                        icon: Icons.group_add,
                        onPressed: () async {
                          // Chờ cho AddMemberToEventScreen trở về với kết quả
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMemberToEventScreen(),
                            ),
                          );

                          // Nếu kết quả từ AddMemberToEventScreen là true, gọi lại hàm để cập nhật dữ liệu
                          if (result == true) {
                            await getUserRole();
                            await fetchAllMembers();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Danh sách các member item
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: UIMemberItem(
                            member: members[index],
                            onTap: () {
                              _showMemberInfoModal(members[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}