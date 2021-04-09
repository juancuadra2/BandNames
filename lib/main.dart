import 'package:band_names/app/pages/home_page.dart';
import 'package:band_names/app/pages/server_status.dart';
import 'package:band_names/app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage()
        },
      ),
    );
  }
}