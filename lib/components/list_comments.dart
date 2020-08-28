import 'package:flutter/material.dart';

class ListComments extends StatefulWidget {
  @override
  _ListCommentsState createState() => _ListCommentsState();
}

class _ListCommentsState extends State<ListComments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("69 Comments"),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () => print("sort"),
            )
          ],
        ),
      ],
    );
  }
}
