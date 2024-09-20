import 'package:flutter/material.dart';

typedef ButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onTap,
);

typedef MenuBuilder = Widget Function(
  BuildContext context,
  double? width,
);

enum MenuPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class RawFlexDropDown extends StatefulWidget {
  const RawFlexDropDown({
    super.key,
    required this.controller,
    required this.buttonBuilder,
    required this.menuBuilder,
    this.menuPosition = MenuPosition.bottomLeft,
  });

  final OverlayPortalController controller;

  final ButtonBuilder buttonBuilder;
  final MenuBuilder menuBuilder;
  final MenuPosition menuPosition;

  @override
  State<RawFlexDropDown> createState() => _RawFlexDropDownState();
}

class _RawFlexDropDownState extends State<RawFlexDropDown> {
  final _link = LayerLink();

  /// width of the button after the widget rendered
  double? _buttonWidth;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: widget.controller,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: switch (widget.menuPosition) {
              MenuPosition.topLeft => Alignment.topLeft,
              MenuPosition.topRight => Alignment.topRight,
              MenuPosition.bottomLeft => Alignment.bottomLeft,
              MenuPosition.bottomRight => Alignment.bottomRight,
            },
            followerAnchor: switch (widget.menuPosition) {
              MenuPosition.topLeft => Alignment.bottomLeft,
              MenuPosition.topRight => Alignment.bottomRight,
              MenuPosition.bottomLeft => Alignment.topLeft,
              MenuPosition.bottomRight => Alignment.topRight,
            },
            showWhenUnlinked: false,
            child: Align(
              alignment: switch (widget.menuPosition) {
                MenuPosition.topLeft => AlignmentDirectional.bottomStart,
                MenuPosition.topRight => AlignmentDirectional.bottomEnd,
                MenuPosition.bottomLeft => AlignmentDirectional.topStart,
                MenuPosition.bottomRight => AlignmentDirectional.topEnd,
              },
              child: widget.menuBuilder(context, _buttonWidth),
            ),
          );
        },
        child: widget.buttonBuilder(context, onTap),
      ),
    );
  }

  void onTap() {
    _buttonWidth = context.size?.width;

    widget.controller.toggle();
  }
}
