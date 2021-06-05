import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'video_view.dart';

class SingleVideo extends StatelessWidget {
  SingleVideo(this.document);

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => _openVideo(context, document),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                children: [
                  Container(
                      height: 150, child: Image.network(document.get('thump'))),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                    child: Text(
                      document.get('name'),
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                    child: Text(
                      document.get('cat'),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, DocumentSnapshot document) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VideoView(document)));
  }
}
