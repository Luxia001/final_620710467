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

  List<Quiz>? ques;
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
     ques = list.map((item) =>  Quiz.fromJson(item)).toList();

    });
  }

  void guess(String choice, int ans) {
    setState(() {
      if (ques![count].choices[ans] == choice) {
        text = "เก่งมากครับ";
      } else {
        text = "ตอบผิดครับ";
      }
    });
    Timer time = Timer(Duration(seconds: 1), () {
      setState(() {
        text = "";
        if (ques![count].choices[ans] == choice) {
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
      body: ques != null && count < ques!.length
          ?buildQuiz() : ques != null && count == ques!.length
          ?buildTryAgain()
          :const Center(child: CircularProgressIndicator(),),
    );
  }
  Widget buildTryAgain(){
    CrossAxisAlignment.center;
    return Center(

      child: Center(
        child: Column(
          children: [
            Text('End'),
            Text('ทายผิด ${wrong}'),
          ]
        ),
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
            Image.network(ques![count].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < ques![count].choices.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(ques![count].choices[i].toString(),ques![count].answer),
                            child: Text(ques![count].choices[i]),
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