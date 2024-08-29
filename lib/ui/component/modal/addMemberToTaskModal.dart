import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMemberToTaskSModal extends StatefulWidget {

  const AddMemberToTaskSModal({Key? key}): super(key: key);

  @override
  State<AddMemberToTaskSModal> createState() => _AddMemberToTaskSModalState();
}

class _AddMemberToTaskSModalState extends State<AddMemberToTaskSModal> {
  final EventRepository _eventRepository = EventRepository();
  final TaskRepository _taskRepository = TaskRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  late List<AddMemberItem> members;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
    try {
      final response =
          await _eventRepository.getMemberAssign(eventProvider.eventId, eventProvider.taskId);
      if (response['EC'] == 0) {
        // print(response['DT']);
        setState(() {
          members = (response['DT'] as List).map((user) {
            return AddMemberItem(
              avatarURL: user['avatarUrl'] ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
              name: user['name'],
              email: user['email'],
              isChecked: false,
              userId: user['id'],
            );
          }).toList();
          // print("response");
          // print(response);
          isLoading = false;
        });
      } else {
        print(response['EM']);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMemberToTask() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        bool success = true;
      for (final member in members) {
        if (member.isChecked) {
          final response = await _taskRepository.addMemberToTask(
              eventProvider.taskId, member.userId);
          if (response['EC'] == 0) {
            final notify = await _notificationRepository.createNotifycation(
                'createuser',
               "Sự kiện ${eventProvider.eventName} : ${authProvider.fullName}, đã thêm ${member.name} vào công việc ${eventProvider.taskName}!",
                eventProvider.eventId,
                authProvider.id);
          } else {
            success = false;
            UIToastNN.showToastError(response['EM']);
            print(
                'Failed to add user ${member.name} to the event: ${response['EM']}');
          }
        }
      }
      if (success) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error adding user to event: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        children: members.map((member) {
                          return UIAddMemberItem(
                            member: member,
                            onTap: () {
                              setState(() {
                                member.isChecked = !member.isChecked;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child: Row(
          children: [
             UICustomButton(
                buttonText: "Giao việc",
                onPressed: addMemberToTask,
                ),
          ],
        ),
      ),
    );
  }
}

class AddMemberItem {
  final String avatarURL;
  final String name;
  final String email;
  final String userId;
  bool isChecked;

  AddMemberItem({
    required this.avatarURL,
    required this.name,
    required this.email,
    required this.userId,
    this.isChecked = false,
  });
}

class UIAddMemberItem extends StatelessWidget {
  final AddMemberItem member;
  final VoidCallback onTap;

  UIAddMemberItem({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.network(
                  member.avatarURL,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
            ),
            // VerticalDivider(color: Colors.grey),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: 
                Column(
                  children: [
                  Text(
                  member.name,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  member.email,
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                  ],
                )
                
              ),
            ),
            // VerticalDivider(color: Colors.grey),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Checkbox(
                  value: member.isChecked,
                  onChanged: (bool? value) {
                    // Toggle the isChecked value
                    if (value != null) {
                      onTap();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
