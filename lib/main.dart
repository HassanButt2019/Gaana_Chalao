import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as awesome;
import 'package:gaana_chalao/screens/home.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:gaana_chalao/screens/upload.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaana Chalao',
      debugShowCheckedModeBanner: false,
      home: GaanaChalao(),
      theme: ThemeData(
        primaryColor: Color(0xff5e35b1),
      ),
    );
  }
}

class GaanaChalao extends StatefulWidget {

  String  song_name , album_name , singer_name , song_url,image_url;
  GaanaChalao({this.song_name , this.album_name , this.singer_name , this.song_url , this.image_url});
  @override
  _GaanaChalaoState createState() => _GaanaChalaoState();
}

class _GaanaChalaoState extends State<GaanaChalao> {


 // final player = AudioPlayer();
//  double _dragValue;
//  var duration;


  final musicPlayer = AudioPlayer();
//
  Duration duration = new Duration();
  Duration position = new Duration();




  void initPlayer()
  {
    musicPlayer.durationHandler = (d) => setState((){
      duration = d;
    });
    musicPlayer.positionHandler = (p) => setState((){
      position = p;
    });
  }

  String song;
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    musicPlayer.seek(newDuration);
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
  //MusicPlayer musicPlayer;

  //var duration;
  @override
  void initState()
  {
    super.initState();
    initPlayer();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Gaana Chalao")),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x46000000),
                        offset: Offset(0, 10),
                        spreadRadius: 0,
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      image: NetworkImage(
                          widget.image_url??"https://www.w3schools.com/w3css/img_lights.jpg"),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  widget.song_name?? "Song Name",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  widget.album_name?? "Album Name",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Text(
                    widget.singer_name??"Singer Name",
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Slider(
                  min: 0.0,
                  value:position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      seekToSecond(value.toInt());
                      value =  value;
                    });
                  },
                  activeColor: Color(0xff5e3581),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {},
                          icon: Icon(awesome.FontAwesomeIcons.backward),
                        ),
                      ),
                      IconButton(
                        iconSize: 60,
                        onPressed: () {
                       //   audioCache.play(widget.song_url);
                            musicPlayer.play(widget.song_url);
                        },
                        icon: Icon(
                          awesome.FontAwesomeIcons.play,
                        ),
                      ),
                      IconButton(
                        iconSize: 60,
                        onPressed: () {
                         // audioCache.pause();
                          musicPlayer.pause();
                        },
                        icon: Icon(
                          awesome.FontAwesomeIcons.pause,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {},
                          icon: Icon(awesome.FontAwesomeIcons.forward),
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
