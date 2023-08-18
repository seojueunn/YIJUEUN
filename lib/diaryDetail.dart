import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'writing.dart';
import 'Login/login.dart';
import 'enterDiary.dart';
import 'home.dart';

class DetailPage extends StatefulWidget {
  final String diaryId;

  const DetailPage(this.diaryId, {Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  List<Card> _buildListCards(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

    if (snapshot.data != null) {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Card(
          color: Color(0xffCAF99B),
          clipBehavior: Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            '\u{1F308}   ' + data['date'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WritingPage(widget.diaryId, document.id)
                                )
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    } else {
      return [];
    }
  }

  int currentIndex = 0;
  final List<Widget> _children = [const HomePage(), const EnterDiary()];

  String currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String createDate = DateFormat('yyyy.MM.dd (EEE)').format(DateTime.now()).toUpperCase();

  String _currentAddress = "";

  void getLocation() async{
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.
    getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> place = await placemarkFromCoordinates(
        position.latitude,
        position.longitude);
    Placemark place2 = place[0];
    _currentAddress = "${place2.locality}, ${place2.country}";
    //print(_currentAddress);

  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading:  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'Add Product',
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () async {
                print('Add');

                final diaryDocument = FirebaseFirestore.instance.collection('diary').doc(widget.diaryId).collection('diaryList').doc(currentdate);
                var checkDiary = await diaryDocument.get();
                if (!checkDiary.exists) {
                  print('New diary (' + currentdate + ')');
                  diaryDocument.set({
                    'contents': '',
                    'date': createDate,
                    'location': _currentAddress,
                  });
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WritingPage(widget.diaryId, currentdate)
                    )
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Color(0xff629E44)),
          child: BottomNavigationBar(
            selectedItemColor: Colors.white,
            showSelectedLabels: false,
            unselectedItemColor: Colors.white,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: (index) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _children[index]),
              );
            },
            items: <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,),
                label: 'home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'search'
              ),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (!snapshot.hasData) {
                return const LoginPage();
              }
              else{
                String uid = snapshot.data!.uid;
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('diary').doc(widget.diaryId).collection('diaryList').snapshots(),
                  builder: (BuildContext context, _snapshot) {
                    if (_snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    return ListView(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 130,
                                  child: Text(
                                    widget.diaryId,
                                    style: TextStyle(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              ),
                              SizedBox(height: 25,),
                              SizedBox(
                                  height: 600,
                                  child: GridView.count(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    crossAxisCount: 1,
                                    padding: const EdgeInsets.all(25.0),
                                    childAspectRatio: 25.0 / 4.0,
                                    children: _buildListCards(context, _snapshot),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }
}