import 'package:flutter/material.dart';
import 'package:quize/auth_Conn/auth.dart';

class MCQUploadScreen extends StatefulWidget {
  @override
  _MCQUploadScreenState createState() => _MCQUploadScreenState();
}

class _MCQUploadScreenState extends State<MCQUploadScreen> {
  final MCQService _mcqService = MCQService();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _choice1Controller = TextEditingController();
  final TextEditingController _choice2Controller = TextEditingController();
  final TextEditingController _choice3Controller = TextEditingController();
  final TextEditingController _choice4Controller = TextEditingController();
  final TextEditingController _correctAnswerController =
      TextEditingController();

  void filedClear(){
    _correctAnswerController.clear();
            _choice1Controller.clear();
            _choice2Controller.clear();
            _choice3Controller.clear();
            _choice4Controller.clear();
            _questionController.clear();
  }
  
  void _uploadMCQ() async {
    String questionText = _questionController.text;
    List<String> choices = [
      _choice1Controller.text,
      _choice2Controller.text,
      _choice3Controller.text,
      _choice4Controller.text
    ];
    String correctAnswer = _correctAnswerController.text;

    String result = await _mcqService.uploadMCQToFirebase(
        questionText, choices, correctAnswer);
    if (result == 'Success') {
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload Succ....')));
           filedClear();
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Faile...')));
            filedClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload MCQ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question Text'),
              ),
              TextField(
                controller: _choice1Controller,
                decoration: InputDecoration(labelText: 'A'),
              ),
              TextField(
                controller: _choice2Controller,
                decoration: InputDecoration(labelText: 'B'),
              ),
              TextField(
                controller: _choice3Controller,
                decoration: InputDecoration(labelText: 'C'),
              ),
              TextField(
                controller: _choice4Controller,
                decoration: InputDecoration(labelText: 'D'),
              ),
              TextField(
                controller: _correctAnswerController,
                decoration: InputDecoration(labelText: 'Correct Answer'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadMCQ,
                child: Text('Upload MCQ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
