
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:path/path.dart'as path;


class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  int currentindex = 0;
  TextEditingController _singer = TextEditingController();
  TextEditingController _album = TextEditingController();
  TextEditingController _song = TextEditingController();

  File image;
  String imagepath;
  StorageReference storageReference;
  var image_down_url;
  var song_down_url;
  final firestore = Firestore.instance;
  void SelectImage() async
  {
    image = await FilePicker.getFile();

    setState(() {
      image = image;
      imagepath = path.basename(image.path);
      uploadImage(image.readAsBytesSync(),imagepath);
    });
  }

  Future<String> uploadImage(List<int> image , String imagepath )async{
  storageReference = FirebaseStorage.instance.ref().child(imagepath);
  StorageUploadTask storageUploadTask = storageReference.putData(image);
  image_down_url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
  
  }
  void ChangeScreen(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UploadScreen()));
    }
  }

  File songUpload;
  String Songpath;

  void  SelectSongs() async
  {
    songUpload = await FilePicker.getFile();

    setState(() {
      songUpload = songUpload;
      Songpath = path.basename(songUpload.path);
      uploadSongs(songUpload.readAsBytesSync() , Songpath);
    });


  }
  Future<String> uploadSongs(List<int> song , String songpath)async
  {
   storageReference = FirebaseStorage.instance.ref().child(songpath);
   StorageUploadTask uploadTask = storageReference.putData(song);
   song_down_url = await (await uploadTask.onComplete).ref.getDownloadURL();
  }


  finalUpload()
  {
    var data = {
      "song_name": _song.text,
      "album_name": _album.text,
      "singer_name": _singer.text,
      "song_url": song_down_url.toString(),
      "image_url": image_down_url.toString(),
    };

    firestore.collection("songs").document().setData(data);
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Gana Chalao",
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Gaana Chalao")),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed:SelectImage,
                    child: Text('Select Image'),
                  ),
                  RaisedButton(
                    onPressed:SelectSongs,
                    child: Text('Select Song'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _song,
                    decoration: InputDecoration(
                      hintText: "Enter Song Name",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _album,
                    decoration: InputDecoration(
                      hintText: "Enter Album Name",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _singer,
                    decoration: InputDecoration(
                      hintText: "Enter Singer Name",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    onPressed:finalUpload,
                    child: Text('Upload'),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload),
              title: Text('Upload'),
            ),
          ],
          onTap: (value) {
            setState(() {
              currentindex = value;
              ChangeScreen(currentindex);
            });
          },
        ),
      ),
    );
  }
}
