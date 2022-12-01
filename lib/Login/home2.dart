import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class Home2 extends StatelessWidget {
  const Home2({Key ?key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF3F6A3),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (!snapshot.hasData) {
              return const LoginPage();
            }
            else {
              return Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${snapshot.data?.displayName}님 반갑습니다:D", style: const TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20,),
                    TextButton(
                      child: const Text('로그아웃', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                    TextButton(
                      child: const Text('시작하기', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),),

                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                  ],
                ),
              );
            }
          },

        ),
      ),
    );

  }
}