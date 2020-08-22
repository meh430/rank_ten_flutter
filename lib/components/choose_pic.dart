import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/dark_theme_provider.dart';

import 'login.dart';

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
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  widget.profilePicker
                      ? "Choose Profile Picture"
                      : "Choose Image",
                  style: textTheme.headline4),
              PreviewImage(
                  imageUrl: _currImage, profilePicker: widget.profilePicker),
              TextField(
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    setState(() {
                      _currImage = value;
                    });
                  },
                  style: textTheme.headline6.copyWith(fontSize: 16),
                  controller: _urlController,
                  decoration: InputDecoration(
                      labelText: 'Image URL',
                      contentPadding: const EdgeInsets.all(20.0),
                      labelStyle: textTheme.headline6.copyWith(fontSize: 16),
                      border: getInputStyle(isDark),
                      enabledBorder: getInputStyle(isDark),
                      focusedBorder: getInputStyle(isDark)))
            ],
          ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(imageUrl, width: 160, height: 90, fit: BoxFit.cover),
    );
  }
}

class PreviewImage extends StatefulWidget {
  final String imageUrl;
  final bool profilePicker;

  PreviewImage({this.imageUrl, this.profilePicker});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  final RankApi _api = RankApi();

  @override
  Widget build(BuildContext context) {
    var inValid = Text("Image url is not valid", style: Theme
        .of(context)
        .primaryTextTheme
        .headline6);
    return FutureBuilder(
      future: _api.validateImage(widget.imageUrl),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return widget.profilePicker
                ? RoundedImage(imageUrl: widget.imageUrl)
                : RankItemImage(imageUrl: widget.imageUrl);
          } else {
            return Padding(
                padding: EdgeInsets.all(12),
                child: inValid);
          }
        } else if (snapshot.hasError) {
          return Padding(
              padding: EdgeInsets.all(12),
              child: inValid);
        }

        return SpinKitRipple(size: 50, color: hanPurple);
      },
    );
  }
}
