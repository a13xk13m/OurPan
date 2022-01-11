import 'package:flutter/material.dart';

// Simple image card that displays the url it is given.
class ImageViewCard extends StatelessWidget {
  late String url;

  ImageViewCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        child: Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              url,
              height: 200,
            )));
  }
}
