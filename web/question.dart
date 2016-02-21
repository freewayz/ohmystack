import 'dart:convert';

class Question {

  List<String> _tags;
  Map _owner;
  bool _isAnswered;
  num _viewCount;
  String _title;
  String _questionAnswerUrl;
  String _questionId;


  String getTitle() => _title;

  String getQuestionAnswerUrl() => _questionAnswerUrl;

  List<String> getTags() => _tags;

  String getQuestionId() => _questionId;

  num getViewCount() => _viewCount;


  Question(String jsonString) {
    Map jsonMapString = JSON.decode(jsonString);
    _tags = jsonMapString['tags'];
    _owner = jsonMapString['owner'];
    _title = jsonMapString['title'];
    _questionId = jsonMapString['question_id"'];
    _questionAnswerUrl = jsonMapString['link'];
    _viewCount = jsonMapString['view_count'];
  }

}