import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quize/auth_Conn/auth.dart';

class userStartQuize extends StatefulWidget {
  @override
  _userStartQuizeState createState() => _userStartQuizeState();
}

class _userStartQuizeState extends State<userStartQuize> {
  final MCQService mcqService = MCQService();
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  Random random = Random();
  Timer? timer;
  ValueNotifier<double> progress = ValueNotifier(1.0);
  ValueNotifier<int> remainingTime = ValueNotifier(60);
  int timeLimit = 60;

  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    progress.dispose();
    remainingTime.dispose();
    super.dispose();
  }

  void startTimer() {
    remainingTime.value = timeLimit;
    progress.value = 1.0;

    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
        progress.value = remainingTime.value / timeLimit;
      } else {
        timer.cancel();
        goToNextQuestion();
      }
    });
  }

  void goToNextQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedAnswer = null;
      startTimer();
    });
  }

  void storeResult(
      String question, String selectedAnswer, String correctAnswer) {
    results.add({
      'question': question,
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': selectedAnswer == correctAnswer,
    });
  }

  double calculateScorePercentage() {
    int correctAnswers = results.where((result) => result['isCorrect']).length;
    return (correctAnswers / results.length) * 100;
  }

  void showFinalResult(BuildContext context, double score) async {
    await uploadResults(results);
    String resultMessage;
    if (score >= 80) {
      resultMessage =
          "Congratulations! You passed with $score% correct answers.";
    } else if (score < 40) {
      resultMessage = "You failed. Only $score% correct answers.";
    } else {
      resultMessage = "You passed, but can improve. $score% correct answers.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text(resultMessage),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Questions'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: mcqService.getMCQsFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No MCQs available'));
          }

          var mcqs = snapshot.data!.docs;

          if (currentQuestionIndex >= mcqs.length) {
            timer!.cancel();
            double score = calculateScorePercentage();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showFinalResult(context, score);
            });
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var result = results[index];
                bool isCorrect = result['isCorrect'];
                return ListTile(
                  leading: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  title: Column(
                    children: [
                      Text(result['question']),
                    ],
                  ),
                  subtitle: Text(
                    'Your answer: ${result['selectedAnswer']}\nCorrect answer: ${result['correctAnswer']}',
                  ),
                );
              },
            );
          }

          var mcq = mcqs[currentQuestionIndex];
          var questionText = mcq['questionText'];
          var choices = List<String>.from(mcq['choices']);
          var correctAnswer = mcq['correctAnswer'];

          List<String> choiceLabels = ['a', 'b', 'c', 'd'];

          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1}) $questionText',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ValueListenableBuilder<double>(
                  valueListenable: progress,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    );
                  },
                ),
                SizedBox(height: 10),
                ValueListenableBuilder<int>(
                  valueListenable: remainingTime,
                  builder: (context, value, child) {
                    return Text('Time left: $value seconds');
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: choices.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<String>(
                        title:
                            Text('${choiceLabels[index]}. ${choices[index]}'),
                        value: choices[index],
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: selectedAnswer != null
                        ? () {
                            storeResult(
                              questionText,
                              selectedAnswer!,
                              correctAnswer,
                            );
                            timer?.cancel();
                            goToNextQuestion();
                          }
                        : null,
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
