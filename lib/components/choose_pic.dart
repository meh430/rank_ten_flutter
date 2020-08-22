import 'package:flutter/material.dart';
import 'package:rank_ten/components/user_info.dart';

class PicChooser extends StatefulWidget {
  final bool profilePicker;
  final String prevImage;

  PicChooser({@required this.profilePicker, @required this.prevImage});

  @override
  _PicChooserState createState() => _PicChooserState();
}

class _PicChooserState extends State<PicChooser> {
  String _currImage;
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _currImage = widget.prevImage;
    _urlController = _currImage == ""
        ? TextEditingController()
        : TextEditingController(text: _currImage);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).primaryTextTheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
                widget.profilePicker
                    ? "Choose Profile Picture"
                    : "Choose Image",
                style: textTheme.headline4),
            widget.profilePicker
                ? RoundedImage(imageUrl: _currImage, uInitial: "P")
                : RankItemImage(imageUrl: _currImage),
            TextField(
              controller: _urlController,
            )
          ],
        ),
      ),
    );
  }
}

void showProfilePicker(BuildContext context, String url) {
  showDialog(
      context: context,
      builder: (context) => PicChooser(profilePicker: true, prevImage: url));
}

class RankItemImage extends StatelessWidget {
  final String imageUrl;

  RankItemImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl == ""
        ? getProfilePic("P", context)
        : ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(imageUrl, width: 160, height: 90),
          );
  }
}
