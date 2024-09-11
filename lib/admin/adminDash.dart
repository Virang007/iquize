import 'package:flutter/material.dart';
import 'package:quize/admin/questions.dart';

class adminDash extends StatefulWidget {
  const adminDash({super.key});

  @override
  State<adminDash> createState() => _adminDashState();
}

class _adminDashState extends State<adminDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Admin'),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MCQUploadScreen()));
            }, child: Text("add Questions")),
            SizedBox(height: 20,),
             
          ],
        ),
      ),
    );
  }
}