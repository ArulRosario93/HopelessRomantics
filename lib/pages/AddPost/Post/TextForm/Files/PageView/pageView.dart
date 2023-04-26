import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/FileContainer.dart';

class pageView extends StatefulWidget {
  pageView({
    super.key,
    required this.file,
    required this.description,
    required this.data,
  });

  final data;
  final file;
  final description;

  @override
  State<pageView> createState() => _pageViewState();
}

class _pageViewState extends State<pageView> {
  bool isImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.file);
    print(widget.file.length);  

    return PageView(
      children: <Widget>[
        for (var i = 0; i <= widget.file.length - 1; i++)
          FileContainer(file: widget.file[i], description: widget.description, data: widget.data, nowWhat: i, lenIT: widget.file.length)
      ],
    );
    // PageView.builder(
    //     onPageChanged: (value) {
    //       setState(() {
    //         _selectedItem = value;
    //       });
    //       setData();
    //     },
    //     itemCount: widget.file.length,
    //     controller: PageController(initialPage: 0, keepPage: true),
    //     itemBuilder: (contex, index) {
    //       return isImage
    //           ? PageViewContainerImage(file: file)
    //           : Container(
    //               child: Text("VIDEO $index"),
    //             );
    //     });
  }
}
