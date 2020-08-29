import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';

import 'login.dart';

typedef SetImage = void Function(String);

class PicChooser extends StatefulWidget {
  final bool profilePicker;
  final String prevImage;
  final SetImage setImage;

  PicChooser(
      {@required this.profilePicker,
      @required this.prevImage,
      @required this.setImage});

  @override
  _PicChooserState createState() => _PicChooserState();
}

class _PicChooserState extends State<PicChooser> {
  String _currImage;
  TextEditingController _urlController;
  bool validImage = false;

  @override
  void initState() {
    super.initState();
    _currImage = widget.prevImage;
    _urlController = _currImage == ""
        ? TextEditingController()
        : TextEditingController(text: _currImage);
  }

  void _setValid(bool valid) {
    validImage = valid;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).primaryTextTheme;
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.profilePicker
                      ? "Choose Profile Picture"
                      : "Choose Image",
                  style: textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              PreviewImage(
                  imageValid: _setValid,
                  imageUrl: _currImage,
                  profilePicker: widget.profilePicker),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => setState(() => _currImage = value),
                    style: textTheme.headline6.copyWith(fontSize: 16),
                    controller: _urlController,
                    onChanged: (value) => setState(() => _currImage = value),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () => _urlController.clear(),
                          child: Icon(Icons.clear,
                              color: isDark ? palePurple : Colors.black,
                              semanticLabel: 'Clear URL'),
                        ),
                        labelText: 'Image URL',
                        contentPadding: const EdgeInsets.all(20.0),
                        labelStyle: textTheme.headline6.copyWith(fontSize: 16),
                        border: getInputStyle(isDark),
                        enabledBorder: getInputStyle(isDark),
                        focusedBorder: getInputStyle(isDark))),
              ),
              const SizedBox(height: 10),
              RaisedButton(
                child: Text("Set Image",
                    style: textTheme.headline6.copyWith(color: palePurple)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: paraPink,
                onPressed: () {
                  if (validImage) {
                    widget.setImage(_currImage);
                  } else {
                    widget.setImage(widget.prevImage);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showProfilePicker({BuildContext context, String url, SetImage setImage}) {
  showDialog(
      context: context,
      builder: (context) =>
          PicChooser(profilePicker: true, prevImage: url, setImage: setImage));
}

void showItemImagePicker(
    {BuildContext context, String url, SetImage setImage}) {
  showDialog(
      context: context,
      builder: (context) =>
          PicChooser(profilePicker: false, prevImage: url, setImage: setImage));
}

class RankItemImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  RankItemImage({@required this.imageUrl, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(imageUrl, fit: fit),
      ),
    );
  }
}

class PreviewImage extends StatefulWidget {
  final String imageUrl;
  final bool profilePicker;
  final imageValid;

  PreviewImage(
      {@required this.imageUrl,
      @required this.profilePicker,
      @required this.imageValid});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  final RankApi _api = RankApi();

  @override
  Widget build(BuildContext context) {
    var inValid = Padding(
      child: Text("Image url is not valid",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.red)),
      padding: const EdgeInsets.all(12),
    );
    return FutureBuilder(
      future: _api.validateImage(widget.imageUrl),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            widget.imageValid(true);
            return widget.profilePicker
                ? RoundedImage(
                    imageUrl: widget.imageUrl,
                    uInitial: "I",
                  )
                : RankItemImage(imageUrl: widget.imageUrl);
          } else {
            widget.imageValid(false);
            return inValid;
          }
        } else if (snapshot.hasError) {
          widget.imageValid(false);
          return inValid;
        }

        return SpinKitRipple(size: 50, color: hanPurple);
      },
    );
  }
}
