import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login/login.dart';
import 'editDiary.dart';

class WritingPage extends StatefulWidget {
  final String diaryId;
  final String diaryIdList;

  const WritingPage(this.diaryId, this.diaryIdList, {Key? key}) : super(key: key);

  @override
  _WritingPageState createState() => _WritingPageState();
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class _WritingPageState extends State<WritingPage> {
  late final Stream<DocumentSnapshot> _diaryDocStream = FirebaseFirestore.instance.collection('diary').doc(widget.diaryId).snapshots();
  late final Stream<DocumentSnapshot> _diaryListDocStream = FirebaseFirestore.instance.collection('diary').doc(widget.diaryId).collection('diaryList').doc(widget.diaryIdList).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return const LoginPage();
        }
        else {
          return StreamBuilder(
            stream: _diaryDocStream,
            builder: (BuildContext context, _snapshot) {
              if (_snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (_snapshot.data == null) {
                return const Text('');
              }

              Map<String, dynamic> diary = _snapshot.data!.data() as Map<String, dynamic>;
              return StreamBuilder(
                stream: _diaryListDocStream,
                builder: (BuildContext context, snapshot_) {

                  if (snapshot_.hasError) {
                    return const Text('');
                  }

                  if (snapshot_.data == null) {
                    return const Text('');
                  }

                  Map<String, dynamic> diaryList = snapshot_.data!.data() as Map<String, dynamic>;
                  TextEditingController _contentsController = TextEditingController(text: diaryList['contents']);
                  return MaterialApp(
                    scaffoldMessengerKey: rootScaffoldMessengerKey,
                    home: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Color(diary['backgroundColor']),
                      appBar: AppBar(
                        backgroundColor: Color(diary['backgroundColor']),
                        elevation: 0,
                        title: Text(
                          diaryList['date'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        bottom: PreferredSize(
                            child: Text('\u{1F4CD} ' + diaryList['location']),
                            preferredSize: Size.zero),
                        leading:  IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black,
                        ),
                      ),
                      body: ListView(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 700,
                                child: Image.network(
                                  diary['background'],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                                child: TextField(
                                  controller: _contentsController,
                                  maxLines: 14,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    height: 2.16,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 35.0,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  print('CLEAR');
                                  _contentsController.clear();
                                },
                              ),
                              SizedBox(width: 70,),
                              IconButton(
                                icon: Icon(
                                  Icons.save_alt,
                                  size: 35.0,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  print('SAVE');

                                  final diaryDocument = FirebaseFirestore.instance.collection('diary').doc(widget.diaryId).collection('diaryList').doc(widget.diaryIdList);
                                  diaryDocument.update({
                                    'contents': _contentsController.text,
                                  });

                                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '일기가 저장되었습니다!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Color(0xff629E44),
                                        duration: Duration(seconds: 2),
                                      )
                                  );
                                },
                              ),
                              SizedBox(width: 70,),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 35.0,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  print('CUSTOM');

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditDiary(widget.diaryId)
                                      )
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              );
            },
          );
        }
      },
    );
  }
}