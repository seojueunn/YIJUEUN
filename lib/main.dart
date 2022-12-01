import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yijueun_jueun/model/model_myDiary.dart';

import 'Login/home2.dart';
import 'Login/login.dart';
import 'addDiary.dart';
import 'home.dart';
import 'enterDiary.dart';
import 'model/model_myDiary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyDiaryProvider()),
      ],
      child: MaterialApp(
        title: 'Shrine',
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/home2': (BuildContext context) => const Home2(),
          '/addDiary': (BuildContext context) => const AddDiary(),
          '/home': (BuildContext context) => const HomePage(),
          '/enterDiary': (BuildContext context) => const EnterDiary(),
        },
      ),
    );
  }
}