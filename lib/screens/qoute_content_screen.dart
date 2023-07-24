import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_gsg/Network_helper/data_helper.dart';

class QuoteContent extends StatefulWidget {
  String imageUrl;
  String content;
  String author;
  List tags = [];

  QuoteContent({
    required this.imageUrl,
    required this.content,
    required this.author,
    Key? key,
  }) : super(key: key);

  @override
  State<QuoteContent> createState() => _QuoteContentState();
}

class _QuoteContentState extends State<QuoteContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchDataAndImage,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 290),
                  child: FloatingActionButton(
                    onPressed: () {
                      fetchDataAndImage();
                    },
                    tooltip: 'Refresh',
                    backgroundColor: Colors.lightGreen,
                    child: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '\u201c',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 70,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    widget.content,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 250),
                    child: Chip(
                      label: Text(widget.author),
                      labelStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchDataAndImage() async {
    final data = await DataHelper().fetchDataQuoteAndImage();
    setState(() {
      widget.content = data['content'] ?? 'Failed to fetch content.';
      widget.author = data['author'] ?? 'Failed to fetch author name.';
      widget.tags = data['tags'] ?? [];
      widget.imageUrl = data['imageUrl'] ?? '';
    });
  }
}
