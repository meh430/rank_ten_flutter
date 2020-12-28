import 'dart:math' show sqrt, max;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:rank_ten/routes/list_screen.dart';
import 'package:rank_ten/routes/login_signup.dart';
import 'package:rank_ten/routes/main_screen.dart';
import 'package:rank_ten/routes/ranked_list_edit_screen.dart';
import 'package:rank_ten/routes/ranked_list_view_screen.dart';
import 'package:rank_ten/routes/splash.dart';
import 'package:rank_ten/routes/user_comments_screen.dart';
import 'package:rank_ten/routes/user_info_screen.dart';
import 'package:rank_ten/routes/user_preview_screen.dart';

const double maxRadius = 1000;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return CircularReveal(
            centerAlignment: Alignment.center, maxRadius: 800, page: Splash());
      case '/login_signup':
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: LoginSignup());
      case '/main':
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: MainScreen());
      case '/lists':
        final ListScreenArgs args = settings.arguments;
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: ListScreen(
                listType: args.listType,
                name: args.name,
                token: args.token,
                userId: args.userId));
      case '/user_preview_list':
        final UserPreviewScreenArgs args = settings.arguments;
        return CircularReveal(
          centerAlignment: Alignment.center,
          maxRadius: maxRadius,
          page: UserPreviewScreen(
              listType: args.listType, name: args.name, id: args.id),
        );
      case '/user_info_screen':
        final UserInfoScreenArgs args = settings.arguments;
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: UserInfoScreen(name: args.name, userId: args.userId));
      case '/ranked_list_view':
        final RankedListViewScreenArgs args = settings.arguments;
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: RankedListViewScreen(
              listId: args.listId,
              listTitle: args.listTitle,
              isMain: args.isMain,
              shouldPushInfo: args.shouldPushInfo,
              profPic: args.profPic,
            ));
      case '/ranked_list_edit':
        final RankedListEditScreenArgs args = settings.arguments;
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: RankedListEditScreen(
                listId: args.listId,
                isNew: args.isNew,
                listTitle: args.listTitle));
      case '/user_comments_screen':
        return CircularReveal(
            centerAlignment: Alignment.center,
            maxRadius: maxRadius,
            page: UserCommentsScreen());
    }
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;

  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInCirc,
              ),
            ),
            child: child,
          ),
        );
}

@immutable
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  CircularRevealClipper({
    @required this.fraction,
    this.centerAlignment,
    this.centerOffset,
    this.minRadius,
    this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final Offset center = this.centerAlignment?.alongSize(size) ??
        this.centerOffset ??
        Offset(size.width / 2, size.height / 2);
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius ?? calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction),
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }
}

class CircularReveal extends PageRouteBuilder {
  final Widget page;
  final AlignmentGeometry centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  // Reveals the next item pushed to the navigation using circle shape.
  //
  // You can provide [centerAlignment] for the reveal center or if you want a
  // more precise use only [centerOffset] and leave other blank.
  //
  // The transition doesn't affect the entry screen so we will only touch
  // the target screen.
  CircularReveal({
    @required this.page,
    this.minRadius = 0,
    @required this.maxRadius,
    this.centerAlignment,
    this.centerOffset,
  })  : assert(centerOffset != null || centerAlignment != null),
        super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: centerAlignment,
        centerOffset: centerOffset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    );
  }
}
