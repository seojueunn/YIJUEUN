import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditDiary extends StatefulWidget {
  final String diaryid;
  const EditDiary(this.diaryid,{Key? key}) : super(key: key);
  EditDiaryState createState() => EditDiaryState(diaryid);
}

enum BG {nothing, line, square}

class EditDiaryState extends State<EditDiary> {
  late String diaryid;
  EditDiaryState(this.diaryid);
  late String url = 'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fsquare.png?alt=media&token=b89c38f4-a869-4da7-a0e7-8f84ddb18040';
  BG _BG = BG.nothing;
  Color _color = Colors.white;


  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance.collection('diary').doc(diaryid).snapshots();


    return StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("");
          }
          if (!snapshot.data!.exists) {
            return const Text("");
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('일기장 CUSTOM',
                style: TextStyle(color: Color(0xff5784A1), fontWeight: FontWeight.bold),),
              leading:  IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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

                Padding(
                  padding:const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  child: Container(
                    width: 300,
                    height: 50,
                    color: _color,
                  ),
                ),

                TextButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: _color, //default color
                                onColorChanged: (Color? color){ //on color picked
                                  setState(() {
                                    _color = color!;
                                  });
                                },
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('DONE'),
                                onPressed: () {
                                  Navigator.of(context).pop(); //dismiss the color picker
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: Text("다이어리 배경색 바꾸기", style: TextStyle(color: Color(0xff5784A1), fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 10.0),
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
                      "backgroundColor" : _color.value,
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('커스텀 완료',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                )
              ],
            ),



          );
        }
    );


  }
}
