import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDropdown extends StatefulWidget {
  final String? value;
  final void Function(String?) onChanged;
  final String? selectedYear;
  final String? selectedSeason;

  const DateDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.selectedYear,
    this.selectedSeason,
  });

  @override
  State<DateDropdown> createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showCalendarOverlay() {
    // Base range (overall project limits)
    DateTime firstDate = DateTime(2024, 3, 4);
    DateTime lastDate = DateTime(2025, 3, 3);

    // Year filtering
    if (widget.selectedYear == "2024") {
      firstDate = DateTime(2024, 3, 4);
      lastDate = DateTime(2024, 12, 31);
    } else if (widget.selectedYear == "2025") {
      firstDate = DateTime(2025, 1, 1);
      lastDate = DateTime(2025, 3, 3);
    }

    // Season filtering within year range
    if (widget.selectedSeason != null &&
        widget.selectedSeason != "Season" &&
        widget.selectedYear != null &&
        widget.selectedYear != "Year") {
      final season = widget.selectedSeason!;
      final int year = int.tryParse(widget.selectedYear!) ?? 0;

      if (season == "Summer") {
        if (year == 2025) {
          firstDate = DateTime(2025, 1, 1);
          lastDate = DateTime(2025, 2, 28);
        } else if (year == 2024) {
          // Project starts Mar 4, so skip Jan–Feb 2024
          firstDate = DateTime(2024, 12, 1);
          lastDate = DateTime(2024, 12, 31);
        }
      }
      if (season == "Autumn") {
        if (year == 2025) {
          // Only allow March 1–3 in 2025
          firstDate = DateTime(2025, 3, 1);
          lastDate = DateTime(2025, 3, 3);
        } else {
          firstDate = DateTime(year, 3, 1);
          lastDate = DateTime(year, 5, 31);
        }
      } else if (season == "Winter") {
        firstDate = DateTime(year, 6, 1);
        lastDate = DateTime(year, 8, 31);
      } else if (season == "Spring") {
        firstDate = DateTime(year, 9, 1);
        lastDate = DateTime(year, 11, 30);
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getWidgetWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Material(
              elevation: 4,
              color: Colors.transparent,
              child: Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.yellow[700]!,
                    onPrimary: Colors.grey[800]!,
                    surface: const Color(0xFF1C1C1C),
                    onSurface: Colors.yellow[700]!,
                  ),
                  dialogBackgroundColor: const Color(0xFF1C1C1C),
                ),
                child: Container(
                  width: 320,
                  color: const Color(0xFF1C1C1C),
                  child: CalendarDatePicker(
                    initialDate: firstDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
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
