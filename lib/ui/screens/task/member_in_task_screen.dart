import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/modal/addMemberToTaskModal.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/component/molcules/UIMemberItem.dart';
import 'package:Eventify/ui/screens/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskMemberScreen extends StatefulWidget {

  const TaskMemberScreen({Key? key}): super(key: key);

  @override
  _TaskMemberScreenState createState() => _TaskMemberScreenState();
}

class _TaskMemberScreenState extends State<TaskMemberScreen> {
  TaskRepository taskRepository = TaskRepository();
  EventRepository eventRepository = EventRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<MemberItem> members = [];
  bool isLoading = true;
  String? userRole;
  Future<void> _deleteMember(String userId, String username) async {
       final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomDialog(
        type: "confirm",
        title: 'Xác nhận',
        content: 'Bạn có chắc chắn muốn hủy giao việc cho thành viên này không?',
        confirmButtonText: 'Xác nhận',
        onConfirm: () async {
              final response = await taskRepository.deleteMemberInTask(
                  eventProvider.taskId, userId);
              if (response['EC'] == 0) {
                // Xóa thành viên khỏi danh sách khi thành công
                           final notify = await _notificationRepository.createNotifycation(
                            'deleteuser',
                            "Sự kiện ${eventProvider.eventName} : ${authProvider.fullName}, đã xóa ${username} khỏi công việc ${eventProvider.taskName}!", 
                            eventProvider.eventId, 
                            authProvider.id);
                setState(() {
                  members.removeWhere((member) => member.userId == userId);
                  Navigator.of(context).pop();
                });
              } else {
                // Xử lý lỗi khi gọi API xóa
                print(response['EM']);
              }
              // Navigator.of(context).pop();
            },
        cancelButtonText: 'Hủy',
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
  }

  @override
  void initState() {
    super.initState();
    getUserRole();
    fetchAllMembers();
  }

  Future<void> getUserRole() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
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
    try {
            final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response = await taskRepository.getMemberInTask(eventProvider.taskId);
      if (response['EC'] == 0) {
        // print('getMemberInTask in task');
        // print(response['DT']);
        setState(() {
          members = (response['DT'] as List).map((member) {
            return MemberItem(
              AvatarURL: member['avatarUrl'] ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
              name: member['name'],
              email: member['email'],
              role: "",
              userId: member['id'],
            );
          }).toList();
          isLoading = false;
        });
      } else {
        print(response['EM']);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching members: $e");
      setState(() {
        isLoading = false;
      });
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
            leading: Icon(Icons.person), 
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
            ListTile(
              leading: Icon(isCurrentUser ? Icons.exit_to_app : Icons.cancel), 
              title: Text(isCurrentUser ? 'Rời công việc' : 'Hủy giao việc'),
              onTap: () {
                Navigator.of(context).pop(); 
                _deleteMember(member.userId, member.name);
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
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final bool isMember = eventProvider.role != 'Member';
    return Scaffold(
         backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          :RefreshIndicator(
              onRefresh: onRefresh, 
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thành viên thực hiện',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                            
                      ),
                      SizedBox(width: 65,),
                      isMember ?
                       UICustomButton(
                        buttonText: "Giao việc",
                        icon: Icons.assignment_ind_outlined,
                        onPressed: () {
                      showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Giao việc",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.0),
                                        Expanded(
                                          child: AddMemberToTaskSModal(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).then((_) {
    
                            fetchAllMembers();
                          });
                        },
                        flex: 2,
                        colors: Colors.blue,
                      )
       
          : Container(),
                    ],
                  ),
                ),

                Expanded(
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
              ],
            ),
          ),
    );
  }
}
