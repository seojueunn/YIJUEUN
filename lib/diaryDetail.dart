import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yijueun_jueun/model/model_myDiary.dart';
import 'Login/login.dart';
import 'enterDiary.dart';
import 'home.dart';
import 'model/model_diary.dart';

class DetailPage extends StatefulWidget {
  final String diaryId;

  const DetailPage(this.diaryId, {Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  List<Card> _buildListCards(BuildContext context, List<Diary> diaries) {

    return diaries.map((diary) {
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
                      Text(
                        diary.diaryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        diary.description,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.favorite),
              onPressed: () {

              },
            ),
          ],
        ),
      );
    }).toList();
  }

  int currentIndex = 0;
  final List<Widget> _children = [const HomePage(), const EnterDiary()];

  @override
  Widget build(BuildContext context) {
    final myDiaryProvider = Provider.of<MyDiaryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detail Page',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        leading:  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.arrow_back)
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(0xff629E44)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          onTap: (index) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _children[index]),
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color:Colors.white,),
              label: 'home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'search'
            ),

          ],
          selectedItemColor: Colors.white,
          // selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
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
              return FutureBuilder(
                future: myDiaryProvider.fetchMyDiariesOrCreate(uid),
                builder: (BuildContext context, _snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  return ListView(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 150,
                            child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/yijueun-a1290.appspot.com/o/images%2Fhome_logo.jpeg?alt=media&token=cb09a7db-b289-4f14-a618-cb4914b1be08'
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                            child: Text("${snapshot.data?.displayName}님, 반갑습니다:D", style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 25,),
                          SizedBox(
                              height: 400,
                              child: GridView.count(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                padding: const EdgeInsets.all(25.0),
                                childAspectRatio: 25.0 / 5.0,
                                children: _buildListCards(context, myDiaryProvider.myDiaries),
                              )
                          ),
                          ElevatedButton(
                            child: Text(
                              '일기장 만들기',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xff629E44)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addDiary');
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
          }
      ),
    );
  }
}