import 'package:flutter/material.dart';

class MemberItem {
  final String AvatarURL;
  final String name;
  final String email;
  final String role;
  final String userId;

  MemberItem({
    required this.AvatarURL, 
    required this.name, 
    required this.email,
    required this.role, 
    required this.userId
    });
}

class UIMemberItem extends StatelessWidget {
  final MemberItem member;
  final VoidCallback onTap;

  UIMemberItem({
    required this.member, 
    required this.onTap, 
  });

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
                  member.AvatarURL,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.height * 0.065,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 6,
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
                ],
              ),
            ),
              SizedBox(width: 10,),
              Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    member.role,
                    style: TextStyle(fontSize: 14,color: Colors.black),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
