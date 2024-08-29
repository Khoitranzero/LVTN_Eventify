import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await TokenService.getToken();
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => AuthProvider(isLoggedIn: widget.isLoggedIn)),
              ChangeNotifierProvider(create: (context) => EventProvider()),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "Eventify",
              theme: ThemeData(
                useMaterial3: true,
                primaryColor: const Color(0xff1a73e8),
                indicatorColor: Colors.blue,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xff1a73e8),
                  foregroundColor: Colors.white,
                  centerTitle: true,
                ),
              ),
              routerConfig: RouterService().router,
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
