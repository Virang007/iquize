import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase MCQ Table',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firebase MCQ Table'),
        ),
        body: MCQScreen(),
      ),
    );
  }
}

class MCQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MCQTable(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Upload a new MCQ to Firebase
            uploadMCQToFirebase();
          },
          child: Text('Upload New MCQ'),
        ),
      ],
    );
  }
}

// Function to upload a new MCQ to Firebase
void uploadMCQToFirebase() async {
  var mcqData = {
    'questionText': 'Which programming language is used in Flutter?',
    'choices': ['Kotlin', 'Dart', 'Java', 'Go'],
    'correctAnswer': 'Dart'
  };

  await FirebaseFirestore.instance.collection('questions').add(mcqData);

  print('MCQ uploaded successfully!');
}

// Widget to fetch and display MCQs from Firestore in a table
class MCQTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('questions').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var questions = snapshot.data!.docs;

        return DataTable(
          columns: [
            DataColumn(label: Text('Question ID')),
            DataColumn(label: Text('Question Text')),
            DataColumn(label: Text('Choices')),
            DataColumn(label: Text('Correct Answer')),
          ],
          rows: questions.map((question) {
            var choices = List.from(question['choices']); // Convert choices field to List

            return DataRow(cells: [
              DataCell(Text(question.id)),
              DataCell(Text(question['questionText'])),
              DataCell(Text(choices.join(', '))), // Show choices as comma-separated values
              DataCell(Text(question['correctAnswer'])),
            ]);
          }).toList(),
        );
      },
    );
  }
}
