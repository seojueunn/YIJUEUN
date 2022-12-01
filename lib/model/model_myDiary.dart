import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_diary.dart';

class MyDiaryProvider with ChangeNotifier {
  late CollectionReference myDiaryReference;
  List<Diary> myDiaries = [];

  MyDiaryProvider({reference}) {
    myDiaryReference = reference ?? FirebaseFirestore.instance.collection('myDiaries');
  }

  Future<void> fetchMyDiariesOrCreate(String uid) async {
    if (uid == '') {
      return;
    }
    final myDiarySnapshot = await myDiaryReference.doc(uid).get();
    if (myDiarySnapshot.exists) {
      Map<String, dynamic> myDiariesMap = myDiarySnapshot.data() as Map<String, dynamic>;
      List<Diary> temp = [];
      for (var diary in myDiariesMap['diaries']) {
        temp.add(Diary.fromMap(diary));
      }
      myDiaries = temp;
      notifyListeners();
    } else {
      await myDiaryReference.doc(uid).set({'diaries': []});
      notifyListeners();
    }
  }

  Future<void> addMyDiary(String uid, Diary diary) async {
    myDiaries.add(diary);
    Map<String, dynamic> myDiariesMap = {
      'diaries': myDiaries.map((diary) {
        return diary.toSnapshot();
      }).toList()
    };
    await myDiaryReference.doc(uid).update(myDiariesMap);
    notifyListeners();
  }

  bool isRecSubIn(Diary diary) {
    return myDiaries.any((element) => element.diaryName == diary.diaryName);
  }
}