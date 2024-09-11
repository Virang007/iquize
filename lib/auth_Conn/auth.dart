import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MCQService {
  Future<String> uploadMCQToFirebase(String questionText, List<String> choices, String correctAnswer) async {
  try {
      var mcqData = {
      'questionText': questionText,
      'choices': choices,
      'correctAnswer': correctAnswer
    };

    await FirebaseFirestore.instance.collection('questions').add(mcqData);
    return 'Success';
  } catch (e) {
    return 'Failed';
  }
  }
    Stream<QuerySnapshot> getMCQsFromFirebase() {
    return FirebaseFirestore.instance.collection('questions').snapshots();
  }

}

class QuizService {
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('questions').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to load questions');
    }
  }
}

 Future<void> uploadResults(List<Map<String, dynamic>> results) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final String? userId = auth.currentUser?.uid;
  if (userId == null) {
    print("User is not authenticated.");
    return;
  }

  try {
    CollectionReference userResults = firestore.collection('quiz_results').doc(userId).collection('results');

    for (var result in results) {
      await userResults.add(result);
    }
    print("Results uploaded successfully!");
  } catch (e) {
    print("Failed to upload results: $e");
  }
}

Future<void> fetchAndPrintAllUsersResults() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    CollectionReference quizResults = firestore.collection('quiz_results');
    QuerySnapshot userSnapshots = await quizResults.get();

    if (userSnapshots.docs.isEmpty) {
      print("No results found.");
      return;
    }

  
    for (var userDoc in userSnapshots.docs) {
      String userId = userDoc.id;
      print("User ID: $userId");

   
      CollectionReference userResults = firestore.collection('quiz_results').doc(userId).collection('results');
      QuerySnapshot resultsSnapshot = await userResults.get();

      if (resultsSnapshot.docs.isEmpty) {
        print("  No quiz results found for this user.");
      } else {
  
        for (var resultDoc in resultsSnapshot.docs) {
          print("  Document ID: ${resultDoc.id}");
          print("  Data: ${resultDoc.data()}");
        }
      }
    }
  } catch (e) {
    print("Failed to fetch results: $e");
  }
}




