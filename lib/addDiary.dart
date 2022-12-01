import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yijueun_jueun/model/model_myDiary.dart';

import 'model/model_diary.dart';


class AddDiary extends StatefulWidget {
  const AddDiary({Key? key}) : super(key: key);
  AddDiaryState createState() => AddDiaryState();

}

class AddDiaryState extends State<AddDiary> {
  late String name, number, description, url;
  FirebaseAuth auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final PWController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  String currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid;
    final myDiaryProvider = Provider.of<MyDiaryProvider>(context);
    myDiaryProvider.fetchMyDiariesOrCreate(uid);

    String defaultBackground = "https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fnothing.png?alt=media&token=a739b2a9-c9a7-4a25-9c0d-96b7ff2611a0";
    String defaultBackgroundColor = "Color(0xff629E44)";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('새로운 일기장 만들기',
          style: TextStyle(color: Color(0xff5784A1), fontWeight: FontWeight.bold),),
        leading:  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home'); //이거 안먹음???
            },
            color: Color(0xff5784A1),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Color(0xffF3F6A3),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: [
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fhome_logo.jpeg?alt=media&token=cb09a7db-b289-4f14-a618-cb4914b1be08',
                height: 300,
                width: 300,),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '일기장 제목',
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Diary Name';
                      }
                      return null;
                    },
                    controller: nameController
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '일기장 설명',
                      //filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Diary Description';
                      }
                      return null;
                    },
                    controller: descriptionController
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '일기장 비밀번호',
                    //filled: true,
                  ),
                  onChanged: (String? newValue) {
                    number = newValue!;
                  },
                  validator: (value) {
                    if(value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: PWController,
                ),
              ),
              Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        //Color.fromARGB(255, 74, 170, 248)
                          const Color(0xff5784A1)
                      ),
                    ),

                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        if(nameController.text != "" || descriptionController.text != "" || PWController.text !=""){
                          final studyCollectionReference = FirebaseFirestore.instance.collection("diary").doc(nameController.text);
                          studyCollectionReference.set({
                            "diaryName": nameController.text,
                            "description": descriptionController.text,
                            "PW": PWController.text,
                            'background': defaultBackground,
                            'backgroundColor': defaultBackgroundColor,
                          });

                          studyCollectionReference.collection("diaryList").doc(currentdate).set({
                            'contents':'',
                          });

                          final myDiarySnapshot = await studyCollectionReference.get();
                          Map<String, dynamic> myDiariesMap = myDiarySnapshot.data() as Map<String, dynamic>;
                          myDiaryProvider.addMyDiary(uid, Diary.fromMap(myDiariesMap));

                          Navigator.pushNamed(context, '/home');
                        }
                      }
                    },
                    child: const Text('등록',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  )
              ),

            ]

        ),
      ),
    );
  }
}