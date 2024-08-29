import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLeaderBottomModal extends StatefulWidget {
  final ScrollController scrollController;
  const ChooseLeaderBottomModal({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<ChooseLeaderBottomModal> createState() =>
      _ChooseLeaderBottomModalState();
}

class _ChooseLeaderBottomModalState extends State<ChooseLeaderBottomModal> {
  final EventRepository _eventRepository = EventRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  late List<AddMemberItem> members;
  late List<AddMemberItem> filteredMembers;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllMembers();
  }

  Future<void> fetchAllMembers() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response =
          await _eventRepository.getMemberInEvents(eventProvider.eventId);
      if (response['EC'] == 0) {
        final List<AddMemberItem> memberList =
            (response['DT'] as List).map((member) {
          return AddMemberItem(
            avatarURL: member['avatarUrl'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
            name: member['name'],
            role: member['role'],
            isChecked: false,
            userId: member['id'],
          );
        }).toList();

        memberList.removeWhere((member) => member.userId == authProvider.id);

        setState(() {
          members = memberList;
          filteredMembers = memberList;
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

  Future<void> updateUserRole(
      String userId, String role, String username) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await _eventRepository.updateUserRole(
          eventProvider.eventId, userId, role);
      if (response['EC'] == 0) {
        final notify = await _notificationRepository.createNotifycation(
          'updateuser',
          "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã bổ nhiệm '${username}' làm '${role}' !",
          eventProvider.eventId,
          authProvider.id,
        );
         UIToastNN.showToastSuccess(
                                "Rời sự kiện thành công !!!");

                            Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error fetching members: $e");
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredMembers = members.where((member) {
        final nameLower = member.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) ||
            member.userId.contains(queryLower) ||
            member.role.contains(queryLower);
      }).toList();
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Chọn trưởng sự kiện trước khi rời',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
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
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor))
                    : ListView.builder(
                        controller: widget.scrollController,
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) {
                          return UIAddMemberItem(
                            member: filteredMembers[index],
                            onTap: () {
                              setState(() {
                                // Uncheck all members
                                for (var member in filteredMembers) {
                                  member.isChecked = false;
                                }
                                // Check the tapped member
                                filteredMembers[index].isChecked = true;
                              });
                            },
                          );
                        },
                      ),
              ),
              SizedBox(height: 16.0),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: UICustomButton(
                          icon: Icons.group_add,
                          buttonText: "Chọn và tiếp tục",
                          onPressed: () {
                            final selectedMember = filteredMembers.firstWhere(
                              (member) => member.isChecked,
                              orElse: () => AddMemberItem(
                                avatarURL: '',
                                name: '',
                                role: '',
                                userId: '',
                                isChecked: false,
                              ),
                            );
                            if (selectedMember.userId.isNotEmpty) {
                              updateUserRole(selectedMember.userId, 'Leader',
                                  selectedMember.name);
                         
                            } else {
                              UIToastNN.showToast(
                                  "Vui lòng chọn một thành viên để tiếp tục.");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
  String role;
  final String userId;
  bool isChecked;

  AddMemberItem({
    required this.avatarURL,
    required this.name,
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
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  member.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
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
