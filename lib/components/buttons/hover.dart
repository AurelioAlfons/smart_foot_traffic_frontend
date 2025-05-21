// hover.dart
// =====================
// - Reusable hoverable icon button
// - Turns yellow when hovered

import 'package:flutter/material.dart';

class HoverableIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const HoverableIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  State<HoverableIconButton> createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<HoverableIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: IconButton(
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon.icon,
          color: _hovering ? Colors.yellow : Colors.white,
          size: widget.icon.size,
        ),
      ),
    );
  }
}
