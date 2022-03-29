import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';

class StyledRefreshIndicator extends StatelessWidget {
  StyledRefreshIndicator({
    required this.onRefresh,
    required this.child,
  });

  final Widget child;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: ThemeSettings.accentColor,
        onRefresh: () => onRefresh(),
        child: child
    );
  }
}