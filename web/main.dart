// Copyright (c) 2016, <Peter Edache>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:google_charts/google_charts.dart' as GChart;
import 'package:js/js.dart' as js;
import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'question.dart';

DivElement relatedQuestion;
DivElement processingSpan;
var stackOverflowUrl = "https://api.stackexchange.com/2.2//search/advanced?order=desc&sort=activity&q";
var stackApiKey = "4ylwye8J)J7fRHZCsDvD3Q((";
List<Question> _listOfResult;
LinkElement viewStackChart;

InputElement stackTextBox;


void main() {
  querySelector("#overflow").onChange.listen(getStackQuestion);
  relatedQuestion = querySelector("#results");
  processingSpan = querySelector("#processing");
  processingSpan..style.visibility = 'hidden';
}


void getStackQuestion(Event e) {
  //empty the relatedQuestions
  relatedQuestion.children.clear();
  //get the question from the input box
  var question = (e.target as InputElement).value;
  //show the loading widget
  //set the stack-overflow api ur to point to the question
  var url = "${stackOverflowUrl}&q=${question}&site=stackoverflow&key=${stackApiKey}";
  var xhr = new HttpRequest();
  xhr
    ..open('GET', url)
    ..onProgress.listen((_) => processingSpan..style.visibility = 'visible')
    ..onLoadEnd.listen((e) {
      processingSpan..style.visibility = 'hidden';
      showData(xhr);
    })
    ..send('');
}


void showData(HttpRequest xhr) {
  if (xhr.status == 200) {
    var data = xhr.responseText;
    Map matchedQuestions = JSON.decode(data);
    Iterable jsonItems = matchedQuestions.values;
    List listOfItems = jsonItems.first;
    List<String> answeredQuestion = new List();

    Map itemQuestion = null;
    for (int i = 0; i < listOfItems.length; ++i) {
      itemQuestion = listOfItems[i];
      if (itemQuestion['is_answered']) {
        answeredQuestion.add(listOfItems[i]);
      }
    }
    _listOfResult = new List();
    for (var j = 0; j < answeredQuestion.length; ++j) {
      print(answeredQuestion[j]);
      _listOfResult.add(new Question(JSON.encode(answeredQuestion[j])));
    }

    setStackChartResult(_listOfResult);
  } else {
    relatedQuestion.children.add(
        new LIElement()
          ..text = 'Ooops an error ocurr, Try again ={$xhr.status}'
    );
  }
}


void setStackChartResult(List<Question> questionResult) {
  questionResult.forEach((question) => relatedQuestion.children.add(
      createCardElement(question)));
}

void setValueForChart(Event event) {
}

String getStackTrace(String _stackTrace) {
  return _stackTrace;
}


void loadPieChart(num answers, num viewCount) {
  GChart.PieChart.load().then((_) {
    var data = GChart.arrayToDataTable(
        [
          ['Data', 'Value'],
          ['Answer Strength', answers],
          ['View Count', viewCount],

        ]
    );

    var options = {'title' : 'Stack Trace Velocity'};

    var chart = new GChart.PieChart(document.getElementById("stack-chart"));
    chart.draw(data, options);
  });
}


DivElement createCardElement(Question qu) {
  var cardHolderClass = ["stack-card-wide", "mdl-card", "mdl-shadow--2dp"];
  var cardTextClass = "mdl-card__supporting-text";
  var cardLink = [
    "mdl-button", "mdl-button--colored", "mdl-js-button", "mdl-js-ripple-effect"
  ];
  DivElement cardHolder = new DivElement()
    ..classes.addAll(cardHolderClass)

  ;
  DivElement cardText = new DivElement()
    ..classes.add(cardTextClass)
    ..innerHtml = qu.getTitle();

  LinkElement viewAnswers =
  new LinkElement()
    ..classes.addAll(cardLink)
    ..text = "View Answers"
    ..href = qu.getQuestionAnswerUrl();


  viewStackChart =
  new LinkElement()
    ..classes.addAll(cardLink)
    ..text = "View Chart"
    ..onClick.listen((e) {
      getQuestionAnswers(qu.getQuestionId(), qu.getViewCount());
    })
  ;

  cardHolder.children.add(cardText);
  cardHolder.children.add(
      new DivElement()
        ..classes.addAll(["mdl-card__actions", "mdl-card--border"])
        ..children.addAll(
            [viewAnswers, viewStackChart]
        )
  );
  return cardHolder;
}

void getQuestionAnswers(String questionId, num viewCount) {
  String stackOverflowQuestionUrl = "https://api.stackexchange.com/2.2/answers/${questionId}?order=desc&sort=activity&site=stackoverflow&key=${stackApiKey}";

  HttpRequest.getString(
      stackOverflowQuestionUrl,
      onProgress: (_) => processingSpan..style.visibility = 'visible')
      .then((response)
  {
    print("Response is " + response);
    Map matchedAnswers = JSON.decode(response);
    List<String> allAnswers = matchedAnswers['items'];
    loadPieChart(allAnswers.length, viewCount);
  }).catchError((_) => print("Error getting answers"));
}



