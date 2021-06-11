import 'package:flutter/material.dart';

class DesktopPageRoute extends MaterialPageRoute {
  DesktopPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
