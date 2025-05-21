import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDropdown extends StatefulWidget {
  final String? value;
  final void Function(String?) onChanged;

  const DateDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<DateDropdown> createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showCalendarOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getWidgetWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            color: Colors.transparent,
            child: Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.amber, // selected circle
                  onPrimary: Colors.grey[800]!, // text inside selected
                  surface: const Color(0xFF1C1C1C), // calendar bg
                  onSurface: Colors.white, // default text
                ),
                dialogBackgroundColor: const Color(0xFF1C1C1C),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CalendarDatePicker(
                  initialDate: DateTime(2024, 3, 4),
                  firstDate: DateTime(2024, 3, 4),
                  lastDate: DateTime(2024, 3, 31),
                  onDateChanged: (picked) {
                    widget.onChanged(DateFormat('yyyy-MM-dd').format(picked));
                    _removeOverlay();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  double _getWidgetWidth() {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showCalendarOverlay();
          } else {
            _removeOverlay();
          }
        },
        child: AbsorbPointer(
          child: DropdownButtonFormField<String>(
            value: widget.value,
            iconEnabledColor: Colors.white,
            dropdownColor: Colors.black,
            decoration: InputDecoration(
              labelText: 'Date',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.amber),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            items: widget.value != null
                ? [
                    DropdownMenuItem(
                      value: widget.value,
                      child: Text(widget.value!),
                    )
                  ]
                : [],
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
