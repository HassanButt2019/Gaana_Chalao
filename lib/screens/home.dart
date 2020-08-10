import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaana_chalao/main.dart';
import 'package:gaana_chalao/screens/upload.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreeState createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScreen> {
  Future getData() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("songs").getDocuments();
    return querySnapshot.documents;
  }

  int currentindex = 0;
  void ChangeScreen(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UploadScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gana Chalao",
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Gaana Chalao")),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute
                          (builder: (context)=>GaanaChalao(
                          song_name:snapshot.data[index].data["song_name"],
                          album_name:snapshot.data[index].data["album_name"],
                          singer_name:snapshot.data[index].data["singer_name"],
                          song_url:snapshot.data[index].data["song_url"],
                          image_url:snapshot.data[index].data["image_url"],
                        )));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Container(
                            height: 60.0,
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.crop_square,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Center(
                                          child: Text(
                                            snapshot
                                                .data[index].data["song_name"],
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[index]
                                                    .data["album_name"],
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[index]
                                                    .data["singer_name"],
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              elevation: 10.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
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
