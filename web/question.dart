import 'dart:convert';

class Question {

  List<String> _tags;
  Map _owner;
  bool _isAnswered;
  num _viewCount;
  String _title;
  String _questionAnswerUrl;


  String getTitle() => _title;

  String getQuestionAnswerUrl() => _questionAnswerUrl;


  Question(String jsonString) {
    Map jsonMapString = JSON.decode(jsonString);
    _tags = jsonMapString['tags'];
    _owner = jsonMapString['owner'];
    _title = jsonMapString['title'];
    _questionAnswerUrl = jsonMapString['link'];
  }

}