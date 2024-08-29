import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/repository/account/accountRepository.dart';
import 'package:Eventify/data/repository/user/userRepository.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/screens/authentication/change_password/changePassword_screen.dart';
import 'package:Eventify/ui/screens/user/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final UserRepository _userRepository = UserRepository();
  final AccountRepository _accountRepository = AccountRepository();
  
  RouterService routerService = RouterService();
  bool _isDark = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchUsers(authProvider.id);
    });
  }

  Future<void> fetchUsers(String userId) async {
    try {
      final response = await _userRepository.getOneUser(userId);
      setState(() {
        userData = response['DT'];
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }



Future<void> _showDeleteAccountDialog(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomDialog(
        type: "delete",
        title: 'Xác nhận xóa tài khoản',
        content: 'Bạn có chắc chắn muốn xóa tài khoản không ?',
        confirmButtonText: 'Xác nhận',
        onConfirm:   
         () async {
 
            var result =  await _accountRepository.deleteUser(userData?['email']);
             print("result EC là :");
             print(result['EC']);
             if(result['EC']==0){
              await authProvider.logout();
  
             routerService.goToLogin(context);
             } 
             Navigator.of(context).pop();         
          }, onCancel: () { Navigator.of(context).pop(); },
      );
    },
  );
}

Future<void> _showLogoutDialog(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomDialog(
        type: "confirm",
        title: 'Xác nhận đăng xuất',
        content: 'Bạn có chắc chắn muốn đăng xuất không ?',
        confirmButtonText: 'Xác nhận',
        onConfirm:   
          () async {

          await authProvider.logout();

          routerService.goToLogin(context);
    
          Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tài khoản'),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: userData == null
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : Column(
                      children: [
                        SizedBox(height: 35.0),
                      Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue, // Màu viền
                          width: 5, // Độ dày của viền
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          userData?['avatarUrl'] ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.34,
                          height: MediaQuery.of(context).size.height * 0.16,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),

                        const SizedBox(height: 8.0),
                        Text(
                            '${userData?['name']?.toString() ?? 'N/A'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text(
                            '${userData?['email']?.toString() ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 64.0),
          Expanded(
            child: Container(
               decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView(
                children: [
                  _SingleSection(
                    children: [
                      _CustomListTile(
                        title: "Thông tin chi tiết",
                        icon: Icons.person_outline_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(userId: authProvider.id),
                          ),
                        ).then((_) {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          fetchUsers(authProvider.id);
                        }),
                      ),
                    ],
                  ),

               
                  _SingleSection(
                    children: [
                      _CustomListTile(
                        title: "Đổi mật khẩu",
                        icon: Icons.lock_outline,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        ),
                      ),
                      _CustomListTile(
                        title: "Đăng xuất",
                        icon: Icons.exit_to_app_rounded,
                        onTap: () async {
                          _showLogoutDialog(context);
                       
                        },
                      ),
                      _CustomListTile(
                        title: "Xóa tài khoản",
                        icon: Icons.delete,
                        onTap: () async {
                           _showDeleteAccountDialog(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
