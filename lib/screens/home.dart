import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Network_helper/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String imageUrl = '';
  String content = '';
  String author = '';
  List<dynamic> tags = [];

  @override
  void initState() {
    super.initState();
    fetchDataAndImage();
  }

  Future<void> fetchDataAndImage() async {
    await fetchDataQuote();
    await fetchImage();
  }

  Future<void> fetchDataQuote() async {
    Map<String, dynamic> data = await NetworkHelper().getQuoteData();

    setState(() {
      content = data['content'] ?? 'Failed to fetch content.';
      author = data['author'] ?? 'Failed to fetch author name.';
      tags = data['tags'] ?? [];
    });
    print('quote');
  }

  Future<void> fetchImage() async {
    print('image');
    String apiUrl = 'https://random.imagecdn'
        '.app/v1/image?width=500&height=550&category=type&format=json';
    if (tags.isNotEmpty) {
      apiUrl = apiUrl.replaceAll('type', tags[0].toString());
      String url = await NetworkHelper().getImage(apiUrl);
      setState(() {
        imageUrl = url ?? 'Failed to fetch image.';
      });
    }
  }

  void refreshData() {
    setState(() {
      imageUrl = '';
      content = '';
      author = '';
      tags = [];
    });
    fetchDataAndImage();
  }
  //todo
  // Future<void> takeScreenshotAndShare() async {
  //   try {
  //     Future<Uint8List> boundary =
  //         _screenshotController.captureFromWidget(Screenshot(
  //       controller: _screenshotController,
  //       child: const Scaffold(
  //         body: Center(
  //           child: HomeScreen(), // Replace with your HomeScreen widget here
  //         ),
  //       ),
  //     ));
  //
  //     ui.Image image = await boundary.toImage();
  //     ByteData byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List uint8List = byteData.buffer.asUint8List();
  //
  //     // Share the screenshot with other apps
  //     await Share.shareFiles(['screenshot.png'],
  //         bytesOfFile: uint8List, text: 'Check out this screenshot!');
  //   } catch (e) {
  //     print('Error capturing screenshot and sharing: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.2)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 290),
                child: FloatingActionButton(
                  onPressed: refreshData,
                  tooltip: 'Refresh',
                  backgroundColor: Colors.blueGrey,
                  child: const Icon(Icons.refresh),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                '\u201c',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 70,
                    color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  content,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  height: 48,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 280),
                      child: Chip(
                        label: Text(author),
                        labelStyle: const TextStyle(color: Colors.black54),
                      ))),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // takeScreenshotAndShare();
        },
        tooltip: 'Take Screenshot and Share',
        child: const Icon(Icons.share),
      ),
    );
  }
}
//
