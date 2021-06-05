import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_app/single_vidio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DashBoard'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return new ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document =
                            snapshot.data.docs[index];
                        return new SingleVideo(document);
                      });
              }
            }));
  }
}
