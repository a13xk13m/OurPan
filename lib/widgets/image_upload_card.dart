import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// TODO: Determine if passed an XFile or string(URL) and render image
// accordingly.

// Widget that represents an image upload button.
// Shows either an white card with a choose photo or take photo
// or a card with the image and then the same options overlayed.
class ImageUploadCard extends StatefulWidget {
  Function updateImage;
  int index;
  bool edit;
  XFile? img;
  bool editable = true;

  ImageUploadCard(
      Key key, this.updateImage, this.index, this.edit, this.img, this.editable)
      : super(key: key);

  State<StatefulWidget> createState() {
    return _ImageUploadCardState();
  }
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  bool imgChosen = false;
  XFile? img;
  late int index;
  late Function updateImage;
  late bool edit;
  late bool editable;
  ImagePicker picker = ImagePicker();

  void initState() {
    super.initState();
    index = widget.index;
    updateImage = widget.updateImage;
    edit = widget.edit;
    img = widget.img;
    editable = widget.editable;
  }

  @override
  Widget build(BuildContext context) {
    // Renders a card with the image as the backdrop, or a card of width 200
    // if no image has been added.
    return img != null
        ? Container(
            child: Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(alignment: Alignment.center, children: [
                  img != null
                      ? Image.file(
                          File(img!.path),
                          height: 200,
                        )
                      : Column(children: [
                          SizedBox(height: 30),
                          Text('Choose an Image')
                        ]),
                  editable
                      ? edit
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.folder),
                                    onPressed: () async {
                                      XFile? i = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      // Open imagepicker folder.
                                      updateImage(i, index);
                                      setState(() {
                                        img = i;
                                      });
                                    }),
                                IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  onPressed: () async {
                                    XFile? i = await picker.pickImage(
                                        source: ImageSource.camera);
                                    // Open imagepicker camera.
                                    updateImage(i, index);
                                    setState(() {
                                      img = i;
                                    });
                                  },
                                )
                              ],
                            )
                          : SizedBox()
                      : SizedBox()
                ])))
        : Container(
            width: 200,
            child: Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(alignment: Alignment.center, children: [
                  img != null
                      ? Image.file(
                          File(img!.path),
                          height: 200,
                        )
                      : Column(children: [
                          SizedBox(height: 30),
                          Text('Choose an Image')
                        ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.folder),
                          onPressed: () async {
                            XFile? i = await picker.pickImage(
                                source: ImageSource.gallery);
                            // Open imagepicker folder.
                            updateImage(i, index);
                            setState(() {
                              img = i;
                            });
                          }),
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () async {
                          XFile? i = await picker.pickImage(
                              source: ImageSource.camera);
                          // Open imagepicker camera.
                          updateImage(i, index);
                          setState(() {
                            img = i;
                          });
                        },
                      )
                    ],
                  ),
                ])));
  }
}
