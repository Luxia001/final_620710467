import 'dart:async';

import 'package:flutter/material.dart';

import '../model/Quiz.dart';
import '../services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Quiz>? quizList;
  int count = 0;
  int wrong = 0;
  String text = "";
  @override
  void initState() {
    super.initState();
   fetch() ;
  }
  void fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
     quizList = list.map((item) =>  Quiz.fromJson(item)).toList();

    });
  }

  void guess(String choice, int ans) {
    setState(() {
      if (quizList![count].choices[ans] == choice) {
        text = "เก่งมากครับ";
      } else {
        text = "ตอบผิดครับ";
      }
    });
    Timer time = Timer(Duration(seconds: 1), () {
      setState(() {
        text = "";
        if (quizList![count].choices[ans] == choice) {
          count++;
        } else {
          wrong++;
        }
      });
    });
  }

  Widget printText(){
    if(text.isEmpty){
      return SizedBox(height: 20, width: 10,);
    }else if (text == "เก่งมากครับ"){
      return Text(text);
    }else{
      return Text(text);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizList != null && count < quizList!.length
          ?buildQuiz() : quizList != null && count == quizList!.length
          ?buildTryAgain()
          :const Center(child: CircularProgressIndicator(),),
    );
  }
  Widget buildTryAgain(){
    return Center(
      child: Column(
        children: [
          Text('End'),
          Text('ทายผิด ${wrong}'),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  wrong =0 ;
                  count =0;
                  quizList = null;
                  fetch();
                });
              }, child: Text('New'),)
        ]
      ),
    );
  }
  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(quizList![count].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < quizList![count].choices.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(quizList![count].choices[i].toString(),quizList![count].answer),
                            child: Text(quizList![count].choices[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printText(),
          ],
        ),
      ),
    );
  }
}