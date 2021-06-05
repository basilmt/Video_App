import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_app/videoUpload.dart';
import 'page/dashboard.dart';
import 'page/explore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid;
  int _currentTab = 0;
  final List<Widget> screens = [
    Explore(),
    //Explore
    Dashboard()
    //Dashboard
  ];

  final PageStorageBucket _bucket = PageStorageBucket();
  Widget _currentScreen = Explore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _gotoVideoUploadPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = screens[0];
                      _currentTab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.explore,
                        color: _currentTab == 0 ? Colors.blue : Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = screens[1];
                      _currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: _currentTab == 1 ? Colors.blue : Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  void _gotoVideoUploadPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VideoUpload()));
  }
}
