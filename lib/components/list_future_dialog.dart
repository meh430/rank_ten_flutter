import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/components/choose_pic.dart';
import 'package:rank_ten/misc/app_theme.dart';

class ListFutureDialog extends StatelessWidget {
  final Future<dynamic> listFuture;

  ListFutureDialog({Key key, @required this.listFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: FutureBuilder(
          future: listFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              Navigator.of(context).pop(true);
              return SizedBox();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error modifying list',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: buildDialogButton(
                          context: context,
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          label: "Ok"),
                    )
                  ],
                ),
              );
            }

            return Container(
                height: 200, child: SpinKitWave(size: 50, color: hanPurple));
          },
        ));
  }
}
