import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/user/userRepository.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMemberToEventScreen extends StatefulWidget {
  const AddMemberToEventScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberToEventScreen> createState() => _AddMemberToEventScreenState();
}

class _AddMemberToEventScreenState extends State<AddMemberToEventScreen> {
  final UserRepository _userRepository = UserRepository();
  final EventRepository _eventRepository = EventRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  String role = 'Member';
  late List<AddMemberItem> members;
  late List<AddMemberItem> filteredMembers;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response = await _userRepository.getAllUser(eventProvider.eventId);
      if (response['EC'] == 0) {
        setState(() {
          members = (response['DT'] as List).map((user) {
            return AddMemberItem(
              avatarURL: user['avatarUrl'] ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
              name: user['name'],
              email:user['email'],
              role: role,
              isChecked: false,
              userId: user['id'],
            );
          }).toList();
          filteredMembers = members.take(10).toList();
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

  Future<void> addUserToEvent() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = true;
      for (final member in members) {
        if (member.isChecked) {
          final response = await _eventRepository.addUserToEvent(
              eventProvider.eventId, member.userId, member.role);
          if (response['EC'] != 0) {
            success = false;
            UIToastNN.showToastError(response['EM']);
          } else if (response['EC'] == 0) {
              final notify = await _notificationRepository.createNotifycation(
            'createuser',
            "${authProvider.fullName}, đã thêm ${member.name} vào sự kiện ${eventProvider.eventName}!", 
            eventProvider.eventId, 
            authProvider.id);
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

  void filterUsers(String query) {
    setState(() {
      filteredMembers = members.where((member) {
        final nameLower = member.name.toLowerCase();
        final emailLower = member.email.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) ||
            member.userId.contains(queryLower) ||
            member.role.contains(queryLower)||
            emailLower.contains(queryLower)
            ;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Thêm thành viên'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: 
           TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thành viên',
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
              onChanged: (value) {
                filterUsers(value);
              },
            ),

            
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        children: filteredMembers.isNotEmpty
                            ? filteredMembers.map((member) {
                                return UIAddMemberItem(
                                  member: member,
                                  onTap: () {
                                    setState(() {
                                      member.isChecked = !member.isChecked;
                                    });
                                  },
                                );
                              }).toList()
                            : [
                                Container(),
                              ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    bottomSheet: Container(
  color: Colors.white, 
  child: Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Expanded(
          child: UICustomButton(
            icon: Icons.group_add,
            buttonText: "Thêm thành viên",
            onPressed: () {
              addUserToEvent();
            },
          ),
        ),
      ],
    ),
  ),
),

    );
  }
}

class AddMemberItem {
  final String avatarURL;
  final String name;
  final String email;
  String role;
  final String userId;
  bool isChecked;

  AddMemberItem({
    required this.avatarURL,
    required this.name,
     required this.email,
    required this.role,
    required this.userId,
    this.isChecked = false,
  }) : assert(role.isNotEmpty);
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
        height: MediaQuery.of(context).size.height * 0.08,
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
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.network(
                  member.avatarURL,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.height * 0.065,
                ),
              ),
              color: Colors.white,
            ),

            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    member.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    member.email,
                   style: TextStyle(fontSize: 14,color: Colors.grey),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] 
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Checkbox(
                  checkColor: Colors.lightGreen,
                  value: member.isChecked,
                  onChanged: (bool? value) {
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
