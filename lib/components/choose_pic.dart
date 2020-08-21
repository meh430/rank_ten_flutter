import 'package:flutter/material.dart';

class PicChooser extends StatefulWidget {
  @override
  _PicChooserState createState() => _PicChooserState();
}

class _PicChooserState extends State<PicChooser> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
