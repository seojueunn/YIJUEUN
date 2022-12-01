import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterDiary extends StatefulWidget {
  const EnterDiary({Key? key}) : super(key: key);
  EnterDiaryState createState() => EnterDiaryState();

}

class EnterDiaryState extends State<EnterDiary> {

  late String name, number, description, PW;
  FirebaseAuth auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final PWController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('일기장 입장하기',
            style: TextStyle(color: Color(0xff5784A1), fontWeight: FontWeight.bold),),
          leading:  IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
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
                    width: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '일기장 제목',
                        ),
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter some text';
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
                        labelText: '일기장 비밀번호',
                      ),
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: PWController,
                    ),
                  ),
                  const SizedBox(height: 50,),
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

                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            if(nameController.text != "" || PWController.text !=""){
                              FirebaseFirestore.instance.collection('diary').doc(nameController.text).get().then
                                ((DocumentSnapshot ds){
                                PW = ds["PW"].toString();
                                if(PW == PWController.text.toString()){
                                  Navigator.pushNamed(context, '/home'); //다이어리 상세페이지로 이동
                                };
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Wrong Pass Word!"),
                                  duration: Duration(seconds: 2),)
                            );

                          }

                        },
                        child: const Text('일기장 입장',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                      )
                  ),
                  //const SizedBox(height: 200,),

                ]
            )
        )

    );
  }
}