import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.image, this.quote); //this takes image1 type image
  Image image;
  String quote;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey genkey = GlobalKey();

  bool isNull = true;

  late String quote;

  String kanyeapi = 'https://api.kanye.rest/';

  Future<dynamic> getQuote() async {
    http.Response response = await http.get(Uri.parse(kanyeapi));

    if (response.statusCode == 200) {
      setState(() {
        quote = jsonDecode(response.body)['quote'];
        isNull = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Error occured.Please try again.',
      );
    }
  }

  Future<dynamic> takePicture() async {
    RenderRepaintBoundary boundary =
        genkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    Fluttertoast.showToast(msg: 'Please wait');
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = new File('$directory/photo.png');
    imgFile.writeAsBytes(pngBytes);
    print('Image file created.');
    GallerySaver.saveImage(imgFile.path);
    Fluttertoast.showToast(
      msg: 'Wallpaper saved to Gallery',
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          home: SafeArea(
              child: Container(
        color: Color(0xff4a2c5f),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 15),
            child: Column(children: [
              Container(
                height: 60,
                padding: EdgeInsets.only(left: 7, bottom: 7, right: 7),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color(0xff8e2532), //
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Container(
                  padding: EdgeInsets.only(right: 7, left: 7, bottom: 7),
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Color(0xffb12e3f),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            color: Color(0xffdb364c),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          )),
                      Positioned(
                        top: 6,
                        child: Text(
                          'Wallpaper Generator',
                          style: GoogleFonts.raleway(
                            fontSize: 28,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xffb12e3f),
                  ),
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 7),
                    child: RepaintBoundary(
                      key: genkey,
                      child: Stack(fit: StackFit.expand, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: FittedBox(
                            child: widget.image,
                            fit: BoxFit
                                .fitHeight, //BoxFit.fill for fitting the image in the fitted box.
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, bottom: 20, left: 30, right: 30),
                            child: Text(
                              ' "' +
                                  (!isNull ? quote : widget.quote) +
                                  '" ', //+ ' - Kanye ',
                              strutStyle: StrutStyle(
                                height: 3,
                              ),
                              softWrap: true,
                              style: GoogleFonts.raleway(
                                backgroundColor: Color(0x99FFFFFF),
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff8e2532),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffb12e3f),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Color(0xffdb364c),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text('Save Image',
                              style: GoogleFonts.raleway(
                                fontSize: 21,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                          ),
                        ),
                      ),
                    ),
                    onTap: takePicture,
                    ),
                SizedBox(width: 20),
                InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff8e2532),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffb12e3f),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Color(0xffdb364c),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text('New Quote',
                              style: GoogleFonts.raleway(
                                fontSize: 21,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ),
                    onTap: () {
                      getQuote();
                    }),
              ]),
            ]),
          ),
        ),
      ))),
    );
  }
}
