// Copyright (c) 2016, <Peter Edache>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:google_charts/google_charts.dart' as GChart;
import 'package:js/js.dart' as js;
import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'question.dart';

DivElement relatedQuestion;
var processingSpan;
var stackOverflowUrl = "https://api.stackexchange.com/2.2//search/advanced?order=desc&sort=activity&q";
var stackApiKey = "4ylwye8J)J7fRHZCsDvD3Q((";
List<Question> _listOfResult;


void main() {
  querySelector("#overflow").onChange.listen(getStackQuestion);
  relatedQuestion = querySelector("#results");
  processingSpan = querySelector("#processing");
}


void getStackQuestion(Event e) {
  //get the question from the input box
  var question = (e.target as InputElement).value;
  //show the loading widget
  querySelector("#processing")
    ..text = "Processing.....";
  //set the stackoverflow api ur to point to the question
  var url = "${stackOverflowUrl}&q=${question}&site=stackoverflow&key=${stackApiKey}";
  var xhr = new HttpRequest();
  xhr
    ..open('GET', url)
    ..onLoadEnd.listen((e) {
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
    _listOfResult  = new List();
    for (var j = 0; j < answeredQuestion.length; ++j) {

      _listOfResult.add( new Question(JSON.encode(answeredQuestion[j])));
//      relatedQuestion.children.add(
//          createCardElement(answeredQuestion[j])
//          new LIElement()
//            ..text = answeredQuestion[j]
//            ..classes.add("mdl-list__item")
//      );
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
  questionResult.forEach((question) => relatedQuestion.children.add(createCardElement(question.getTitle(), question.getQuestionAnswerUrl())) );
}

void setValueForChart(Event event) {
}

String getStackTrace(String _stackTrace) {
  return _stackTrace;
}


void loadPieChart() {
  GChart.PieChart.load().then((_) {
    var data = GChart.arrayToDataTable(
        [
          ['Task', 'Hours per Day'],
          ['Work', 11],
          ['Eat', 2],
          ['Commute', 2],
          ['Watch TV', 2],
          ['Sleep', 7]
        ]
    );

    var options = {'title' : 'My Daily Activities'};

    var chart = new GChart.PieChart(document.getElementById("piechart"));
    chart.draw(data, options);
  });
}


DivElement createCardElement(String title, String questionLink) {
  var  cardHolderClass = ["stack-card-wide","mdl-card","mdl-shadow--2dp"];
  var cardTextClass = "mdl-card__supporting-text";
  var cardLink = ["mdl-button", "mdl-button--colored",  "mdl-js-button",  "mdl-js-ripple-effect"];
  DivElement cardHolder = new DivElement()
    ..classes.addAll(cardHolderClass)

  ;
  DivElement cardText = new DivElement()
    ..classes.add(cardTextClass)..innerHtml = title;

  LinkElement viewAnswers =
  new LinkElement()
    ..classes.addAll(cardLink)
    ..text = "View Answer"
    ..href = questionLink;

  cardHolder.children.add(cardText);
  cardHolder.children.add(
      new DivElement()..classes.addAll(["mdl-card__actions", "mdl-card--border"])..children.add(viewAnswers)
  );
  return cardHolder;

}


