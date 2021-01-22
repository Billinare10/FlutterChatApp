import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:the_chat_room/prc/auth/message_form.dart';
import 'package:the_chat_room/prc/message_wall.dart';

import 'auth/stub.dart'
    if (dart.library.io) 'prc/auth/android_auth_provider.dart'
    if (dart.library.html) 'prc/auth/web_auth_provider.dart';

import 'package:the_chat_room/prc/auth/android_auth_provider.dart';
import 'widgets/message_wall.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final store = FirebaseFirestore.instance.collection('chat_messages');

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _signedIn = false;

  @override
  void InitState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        _signedIn = true;
      } else {
        _signedIn = false;
      }
      setState(() {});
    });
  }

  void _signIn() async {
    try {
      final creds = await AuthProvider().signInWithGoogle();
      print(creds);

      setState(() {
        _signedIn = true;
      });
    } catch (e) {
      print('login failed:$e');
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _signedIn = false;
    });
  }

  void _addMessage(String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await widget.store.add({
        'authore': user.displayName ?? 'Anoymous',
        'author_id': user.uid,
        'author_url': user.photoURL ?? "https://placehold.it/100x100",
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'value': value,
      });
    }
  }

  void _deleteMessages(String docId) async {
    await widget.store.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          if (_signedIn)
            InkWell(
              onTap: _signOut,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.logout)),
            ),
        ],
      ),
      backgroundColor: Color(0xffdee2d6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.store.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) {
                    return Center(child: Text('No Messages to display'));
                  }
                  return MessageWall(
                    messages: snapshot.data.docs,
                    onDelete: _deleteMessages,
                  );
                }
              },
            ),
          ),
          if (_signedIn)
            MessageForm(
              onSubmit: _addMessage,
            )
          else
            Container(
              padding: const EdgeInsets.all(5),
              child: SignInButton(
                Buttons.Google,
                padding: const EdgeInsets.all(5),
                onPressed: _signIn,
              ),
            ),
        ],
      ),
    );
  }
}
