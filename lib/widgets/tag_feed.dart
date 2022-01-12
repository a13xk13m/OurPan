import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';

// Feed that displays a list of tags.
// TODO: Currently only displays the tag, more data needs to be merged/
// query process fixed and tags need to be clickable.
class TagFeed extends StatefulWidget {
  late final List<String> tags;

  TagFeed({required this.tags});

  @override
  State<StatefulWidget> createState() {
    return _TagFeedState();
  }
}

class _TagFeedState extends State<TagFeed> {
  late List<String> tags = <String>[];

  @override
  void initState() {
    super.initState();
    tags = widget.tags;
  }

  @override
  Widget build(BuildContext context) {
    return tags.length > 0
        ? ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              return Container(
                  color: CustomColors.bars,
                  child: Text(tags[index],
                      style: TextStyle(
                          fontSize: 16, color: CustomColors.lightText)));
            })
        : Center(
            child: Text('Search for a tag in the box above.',
                style: TextStyle(fontSize: 18, color: CustomColors.darkText)));
  }
}
