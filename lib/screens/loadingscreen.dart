import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kanasapaper/screens/homescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  String apilink = 'https://api.nasa.gov/planetary/apod?api_key=6Bi8vbvUqCaZAboBWpgWwyzmV68lGCRmf6GjWgv4&thumbs=True';
  String kanyeapi = 'https://api.kanye.rest/';

  bool pic = false;


  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    // PermissionStatus permission = await Permission.storage.request();
    print('Please wait while we get the data');
    try {
      http.Response response = await http.get(Uri.parse(apilink));
      http.Response kanyeresponse = await http.get(Uri.parse(kanyeapi));

      if (response.statusCode == 200 && kanyeresponse.statusCode == 200) {
        String body = response.body;
        String quotebody = kanyeresponse.body;

        String quote = jsonDecode(quotebody)['quote'];
        String mediatype = jsonDecode(body)['media_type'];
        if (mediatype == "image") {
          print(jsonDecode(body)['url']);

          Image image = Image.network(jsonDecode(body)['url']);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(image, quote)
              ));
        } else if (mediatype == "video") {
          Image image = Image.network(jsonDecode(body)['thumbnail_url']);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(image, quote)
              ));
        }
      }else {
        Fluttertoast.showToast(msg: 'An error occured. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something\'s not right.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Container(
          color: Color(0xff4a2c5f),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible( 
                  child: Text(
                    'Loading',
                    style: GoogleFonts.raleway(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                SpinKitPianoWave(
                  duration: Duration(milliseconds: 1000),
                  color: Color(0xffc13144),
                  size: 30,
                  // lineWidth: 5,
                  // controller: AnimationController(vsync: this.context, duration: Duration(minutes: 5)),
                )
             ],
            ),
          )
        )
      ),
    );
  }
}

// SpinKi
