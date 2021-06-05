import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'uploadOptions.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoUpload extends StatefulWidget {
  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  final globalKey = GlobalKey<ScaffoldState>();

  File thumpFile;
  File fileMedia;
  bool _med = false;
  final _formKey = GlobalKey<FormState>();
  LocationData _currentPosition;
  String name;
  String category;
  String address = "Location will be collected";
  Location _location = Location();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Please Wait..')
                ],
              ),
            )
          : ListView(
              children: [
                Container(
                  child: Center(
                    child: Text(
                      'Upload Your Videos',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ),
                ),
                if (!_med)
                  InkWell(
                    child: Icon(
                      Icons.image,
                      size: 120,
                    ),
                    onTap: _uploadOptions,
                  ),
                if (_med)
                  Container(
                    padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                    child: Image.file(thumpFile),
                    height: 200,
                  ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Name'),
                            onChanged: (newText) {
                              name = newText;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Category'),
                            onChanged: (newText) {
                              category = newText;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Loc'),
                            initialValue: address,
                            readOnly: true,
                            onChanged: (newText) {
                              address = newText;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Builder(
                              builder: (BuildContext ctx) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (fileMedia == null) {
                                      Scaffold.of(ctx).showSnackBar(SnackBar(
                                          content: Text('No Video Selected')));
                                      // Validate returns true if the form is valid, or false otherwise.
                                    } else if (_formKey.currentState
                                        .validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      _saveToDatabase();
                                    }
                                  },
                                  child: Text('Submit'),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _location.getLocation();
    _getAddress(_currentPosition.latitude, _currentPosition.longitude)
        .then((value) {
      setState(() {
        address = "${value.first.addressLine}";
      });
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  _uploadOptions() async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UploadOptions()));
    if (result == null) {
      return;
    } else {
      var random = new Random();
      int n = random.nextInt(100);
      fileMedia = result;
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image$n.jpg').create();
      file.writeAsBytesSync(await VideoThumbnail.thumbnailData(
        video: fileMedia.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      ));
      thumpFile = file;
      setState(() {
        _med = true;
      });
    }
  }

  Future<void> _saveToDatabase() async {
    setState(() {
      _isLoading = true;
    });

    String thumpUrl = await _uploadToStorage(thumpFile, 'image');
    String fileUrl = await _uploadToStorage(fileMedia, 'video');

    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    if (address == "Location will be collected") {
      address = "Somewhere";
    }

    await posts
        .add({
          'name': name,
          'cat': category,
          'loc': address,
          'uid': FirebaseAuth.instance.currentUser.uid,
          'file': fileUrl,
          'thump': thumpUrl,
          'time': DateTime.now()
        })
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to add post:$error"));

    setState(() {
      _isLoading = false;
    });

    // Waits till the file is uploaded then stores the download url
    // Uri location = (await uploadTask.whenComplete(() => uploadTask.get))
  }

  Future<String> _uploadToStorage(File file, String fName) async {
    Reference _storage = FirebaseStorage.instance.ref();
    Reference reference =
        _storage.child("$fName/${DateTime.now()}.${file.path.split(".").last}");
    await reference.putFile(file);
    return await reference.getDownloadURL();
  }
}
