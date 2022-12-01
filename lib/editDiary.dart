import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditDiary extends StatefulWidget {
  final String diaryid;
  const EditDiary(this.diaryid,{Key? key}) : super(key: key);
  EditDiaryState createState() => EditDiaryState(diaryid);

}

enum BG {nothing, line, square}

class EditDiaryState extends State<EditDiary> {
  late String diaryid;
  EditDiaryState(this.diaryid);
  late String url;

  BG _BG = BG.nothing;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('일기장 CUSTOM',
          style: TextStyle(color: Color(0xff5784A1), fontWeight: FontWeight.bold),),
        leading:  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            color: Color(0xff5784A1),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Color(0xffF3F6A3),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fnothing.png?alt=media&token=a739b2a9-c9a7-4a25-9c0d-96b7ff2611a0',
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 10.0),
                    Text("무지", style: const TextStyle(color: Color(0xff5784A1)),),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fline.png?alt=media&token=f7450f44-405e-41d6-b9e8-a1b9bcb80d22',
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 10.0),
                    Text("줄", style: const TextStyle(color: Color(0xff5784A1)),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fsquare.png?alt=media&token=b89c38f4-a869-4da7-a0e7-8f84ddb18040',
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 10.0),
                    Text("격자", style: const TextStyle(color: Color(0xff5784A1)),),
                  ],
                ),
              ),
            ],
          ),
          RadioListTile(
            title: Text("무지"),
            value: BG.nothing,
            groupValue: _BG,
            onChanged: (BG? value) {
              setState(() {
                _BG = value!;
                //showToast("nothing");
              });
            },
          ),
          RadioListTile(
            title: Text("줄"),
            value: BG.line,
            groupValue: _BG,
            onChanged: (BG? value) {
              setState(() {
                _BG = value!;
                //showToast("nothing");
              });
            },
          ),
          RadioListTile(
            title: Text("격자"),
            value: BG.square,
            groupValue: _BG,
            onChanged: (BG? value) {
              setState(() {
                _BG = value!;
                //showToast("nothing");
              });
            },
          ),
          ElevatedButton(
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
              if(_BG  == BG.square){
                url = 'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fsquare.png?alt=media&token=b89c38f4-a869-4da7-a0e7-8f84ddb18040';
              }
              else if(_BG  == BG.line){
                url = 'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fline.png?alt=media&token=f7450f44-405e-41d6-b9e8-a1b9bcb80d22';
              }
              else if(_BG  == BG.nothing){
                url = 'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fnothing.png?alt=media&token=a739b2a9-c9a7-4a25-9c0d-96b7ff2611a0';

              }

              final studyCollectionReference = FirebaseFirestore.instance.collection("diary").doc(diaryid);
              studyCollectionReference.update({
                "background": url,

              });
              Navigator.pushNamed(context, '/home');


            },
            child: const Text('커스텀 완료',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          )
        ],
      ),



    );
  }
}