import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveNavBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          Spacer(),
          Container(
            width: width * 0.5, // Chiếm nửa màn hình
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color.fromARGB(255, 13, 78, 131), 
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: Text("Trang chủ"),
                  onTap: () {
                    context.go('/home');
                  },
                ),
                ListTile(
                  title: Text("Công việc"),
                  onTap: () {
                    context.go('/tasks'); // Điều hướng đến trang công việc
                  },
                ),
                ListTile(
                  title: Text("Trò chuyện"),
                  onTap: () {
                    context.go('/tasks'); // Điều hướng đến trang công việc
                  },
                ),
                ListTile(
                  title: Text("Cá nhân"),
                  onTap: () {
                    context.go('/profile'); // Điều hướng đến trang cá nhân
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
