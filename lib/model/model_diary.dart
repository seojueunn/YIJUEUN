import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  late String diaryName;
  late String PW;
  late String description;
  late String background;
  late int backgroundColor;

  Diary({
    required this.diaryName,
    required this.PW,
    required this.description,
    required this.background,
    required this.backgroundColor,
  });

  Diary.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    diaryName = data['name'];
    PW = data['PW'];
    description = data['description'];
    background = data['background'];
    backgroundColor = data['backgroundColor'];
  }

  Diary.fromMap(Map<String, dynamic> data) {
    diaryName = data['diaryName'];
    PW = data['PW'];
    description = data['description'];
    background = data['background'];
    backgroundColor = data['backgroundColor'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'diaryName': diaryName,
      'PW': PW,
      'description': description,
      'background': background,
      'backgroundColor': backgroundColor,
    };
  }
}