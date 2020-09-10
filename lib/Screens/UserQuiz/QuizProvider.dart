import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ncrtapp/Screens/UserQuiz/Result.dart';
import 'package:ncrtapp/Screens/UserQuiz/quiz.dart';

class QuizProvider extends ChangeNotifier {
  QuerySnapshot _questionList;
  Map<int, Result> result = {};
  List<Quiz> ques = [];
  int _currentQuestion = 0;

  get length => _questionList.documents.length;
  get current => _currentQuestion;

  getNextQuestion() {
    if (_currentQuestion == length) return null;
    _currentQuestion++;

    return ques[_currentQuestion - 1];
  }

  putResult(String n) {
    result[_currentQuestion - 1].setResult(n);
  }

  getResult() {
    return result[_currentQuestion - 1];
  }

  getPrevQuestion() {
    if (_currentQuestion < 0) return null;
    _currentQuestion--;
    return ques[_currentQuestion];
  }

  fetchAllQuestions(String path) async {
    _questionList = await Firestore.instance.collection(path).getDocuments();

    ques = _questionList.documents.map((e) => Quiz.fromJson(e)).toList();
    for (int i = 0; i < _questionList.documents.length; i++) {
      result[i] = Result(ques[i].op);
    }
    return null;
  }
}
