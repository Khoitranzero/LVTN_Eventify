import 'dart:io';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/repository/user/userRepository.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIModalNN.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? userName;
   String? userEmail;
  String? avatarUrl;
  String? phoneNumber;
  String? defaultAvatar='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU';
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _avatarUrlController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  bool isCurrentUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.id == widget.userId) {
        isCurrentUser = false;
      }
      final userDetails = await _userRepository.getOneUser(widget.userId);
      print("userDetails : $userDetails");
      if (userDetails['EC'] == 0) {
        setState(() {
          userName = userDetails['DT']['name'];
          userEmail = userDetails['DT']['email'];
          avatarUrl = userDetails['DT']['avatarUrl'] ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU';
          phoneNumber = userDetails['DT']['phone'];
          _userNameController.text = userDetails['DT']['name'];
          _userEmailController.text = userDetails['DT']['email'];
          _avatarUrlController.text = userDetails['DT']['avatarUrl'] ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU';
          _phoneNumberController.text = userDetails['DT']['phone'];
        });
      }
    } catch (e) {
      print("Lỗi : $e");
    }
  }

  Future<void> _chooseAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("pickedFile : $pickedFile");

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        print("imageFile : $imageFile");
        final response =
            await _userRepository.changeAvatar(widget.userId, imageFile);
        if (response['EC'] == 0) {
          setState(() {
            avatarUrl = response['DT']['avatarUrl'];
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  Future<void> _updateTaskDetails() async {
    final newUserName = _userNameController.text;
    final newPhoneNumber = _phoneNumberController.text;

    final updateResult = await _userRepository.updateUser(
      newUserName,
      newPhoneNumber,
      widget.userId,
    );


    if (updateResult['EC'] == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return UIModalNN(
                title: "Thông báo",
                message: "Cập nhật thông tin thành công",
                closeButtonText: "Đóng",
                onPressed: () => {Navigator.of(context).pop()});
          });
 
    } else {

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return UIModalNN(
                title: "Thông báo",
                message: "Cập nhật thông tin thất bại, vui lòng thử lại sau",
                closeButtonText: "Đóng",
                onPressed: () => {Navigator.of(context).pop()});
          });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _avatarUrlController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Thông tin chi tiết'),
         leading: IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
  
              SizedBox(height: 16.0),
            Container(
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              avatarUrl != null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 5, 
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.34,
                          height: MediaQuery.of(context).size.height * 0.16,
                          errorBuilder: (context, error, stackTrace) {
                            return ClipOval(
                        child: Image.network(
                          defaultAvatar!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.34,
                          height: MediaQuery.of(context).size.height * 0.16,
                        ),
                      );
                          },
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                   isCurrentUser? Container(): Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 64, 64, 64), 
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white, 
                      size: 20,
                    ),
                    onPressed: isCurrentUser ? null : _chooseAvatar,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),

              SizedBox(height: 32.0),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 32, color: Colors.blue,),
                        SizedBox(width: 10),
                        Expanded(
                          child: 
                        UIAppTextField(
                        hintText: "Tên người dùng",
                        labelText: "Tên người dùng",
                        isReadOnly: isCurrentUser,
                        textController: _userNameController,
                              maxLength: 35,),
                        ),
                         SizedBox(width: 40.0),
                      ],
                    ),                
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(Icons.email, size: 32, color: Colors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: 
                        UIAppTextField(
                        hintText: "Email",
                        labelText: "Email",
                        isReadOnly: true,
                        textController: _userEmailController,
                              maxLength: 35,),
                        ),
                         SizedBox(width: 40.0),
                      ],
                    ),        
                        
                    SizedBox(height: 16.0),
                     Row(
                      children: [
                        Icon(Icons.phone, size: 32, color: Colors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: 
                        UIAppTextField(
                        hintText: "Số điện thoại",
                        labelText: "Số điện thoại",
                        isReadOnly: isCurrentUser,
                        textController: _phoneNumberController,
                              maxLength: 15,),
                        ),
                         SizedBox(width: 40.0),
                      ],
                    ),        
                   
                    SizedBox(height: 16.0),
                    if (!isCurrentUser)
                      Row(
                        children: [
                          SizedBox(width: 40.0),
                          UICustomButton(
                            icon: Icons.refresh,
                            buttonText: 'Cập nhật thông tin cá nhân',
                            onPressed: _updateTaskDetails,
                          ),
                          SizedBox(width: 40.0),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
