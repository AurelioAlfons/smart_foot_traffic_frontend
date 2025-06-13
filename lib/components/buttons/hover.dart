// ====================================================
// Hoverable Icon Button
// ----------------------------------------------------
// - Circle icon button that changes color on hover
// - Calls onPressed when tapped
// - Used for interactive UI navigation/actions
// ====================================================

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
      // If hover
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovering ? Colors.yellow[700] : Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            widget.icon.icon,
            size: widget.icon.size ?? 24,
            color: _hovering ? Colors.white : Colors.white,
          ),
        ),
      ),
    );
  }
}
