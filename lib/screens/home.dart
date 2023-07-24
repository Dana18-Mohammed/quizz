import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_gsg/screens/qoute_content_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../Network_helper/network_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl = '';
  String content = '';
  String author = '';
  List<dynamic> tags = [];
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;

  @override
  void initState() {
    super.initState();
    fetchDataAndImage();
  }

  Future<void> fetchDataAndImage() async {
    final data = await NetworkHelper().fetchDataQuoteAndImage();
    setState(() {
      content = data['content'] ?? 'Failed to fetch content.';
      author = data['author'] ?? 'Failed to fetch author name.';
      tags = data['tags'] ?? [];
      imageUrl = data['imageUrl'] ?? '';
    });
  }

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    print('inside2..');

    await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
    }
  }

  void _onShareXFileFromAssets(BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Scaffold(
        body: QuoteContent(
          imageUrl: imageUrl,
          content: content,
          author: author,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            _capturePng();
          },
          label: const Text('Take screenshot'),
          icon: const Icon(Icons.share_rounded),
        ),
      ),
    );
  }
}
