import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_app/single_vidio.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Explore'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
                        // return new Text(document.get('name'));
                      });
              }
            }));
  }
}
