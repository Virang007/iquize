import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quize/admin/adminDash.dart';

import 'users/userStartQuize.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;
  String _role = 'user';
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@example.com',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            if (!_isLogin) ...[
              DropdownButton<String>(
                value: _role,
                items: ['user', 'admin'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.capitalize()),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
            ],
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _isLogin ? _login : _register,
                    child: Text(_isLogin ? 'Login' : 'Register'),
                  ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin
                  ? "Don't have an account? Register"
                  : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Retrieve user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String userRole = userDoc.get('role');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in as $userRole')),
        );

        if (userRole == 'admin') {
          _passwordController.clear();
          _emailController.clear();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => adminDash()));

          setState(() {
            _isLoading = false;
          });
        } else {
          _passwordController.clear();
          _emailController.clear();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => userStartQuize()));
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login. ${e.message}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'role': _role,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register. ${e.message}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
