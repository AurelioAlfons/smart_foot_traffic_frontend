import 'package:flutter/material.dart';

class CalendarDropdown extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<bool> onDropdownStateChanged;

  final DateTime firstDate;
  final DateTime lastDate;

  const CalendarDropdown({
    super.key,
    required this.onDateSelected,
    required this.onDropdownStateChanged,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CalendarDropdown> createState() => _CalendarDropdownState();
}

class _CalendarDropdownState extends State<CalendarDropdown> {
  DateTime? _selectedDate;
  OverlayEntry? _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  void _toggleCalendar() {
    if (_overlayEntry == null) {
      _showCalendar();
      widget.onDropdownStateChanged(true);
    } else {
      _removeCalendar();
      widget.onDropdownStateChanged(false);
    }
  }

  void _showCalendar() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeCalendar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onDropdownStateChanged(false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height + 5, // little gap below button
        width: 300,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CalendarDatePicker(
              initialDate: _selectedDate ?? widget.firstDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
                widget.onDateSelected(date);
                _removeCalendar(); // Close after picking
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeCalendar(); // clean if page destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: _toggleCalendar,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedDate == null
                    ? "Date"
                    : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _overlayEntry == null
                    ? Icons.arrow_drop_down
                    : Icons.arrow_drop_up,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
