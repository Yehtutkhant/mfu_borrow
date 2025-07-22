import 'package:flutter/material.dart';
import 'package:mfuborrow/myappview.dart';
import 'package:mfuborrow/screens/shared_screeens/login.dart';
import 'package:mfuborrow/screens/staff/create_asset.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: const Color.fromARGB(255, 255, 117, 18),
            secondary: const Color.fromARGB(106, 158, 158, 158),
            onSecondary: const Color.fromARGB(255, 62, 208, 37)),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 249, 248),
      ),
      home: const MyAppView(),
      routes: {
        '/first': (context) => const MyAppView(),
        '/login': (context) => const LoginScreen(),
        '/create_asset': (context) => const CreateAsset(),
      },
      initialRoute: '/first',
    );
  }
}
