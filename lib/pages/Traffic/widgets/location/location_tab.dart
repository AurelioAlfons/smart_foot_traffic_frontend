// ====================================================
// Location Tab List
// ----------------------------------------------------
// - Shows all locations with search and expand feature
// - Expanding a location shows its traffic details
// - Calls callback when a location is tapped
// ====================================================

import 'package:flutter/material.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/location/location_details.dart';
import 'package:smart_foot_traffic_frontend/pages/Traffic/widgets/location/locations.dart';

class LocationTab extends StatelessWidget {
  final Map<String, dynamic>? snapshotData;
  final void Function(String locationName)? onLocationTap;
  final String? searchQuery;

  const LocationTab({
    super.key,
    required this.snapshotData,
    required this.onLocationTap,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    // Filter locations based on search query
    final filteredLocations = allLocations
        .where((location) =>
            searchQuery == null ||
            searchQuery!.isEmpty ||
            // Use lowe
            location.toLowerCase().contains(searchQuery!.toLowerCase()))
        .toList()
      ..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        final data = snapshotData?[location];

        return _CustomExpansionTile(
          location: location,
          data: data,
          onTap: () => onLocationTap?.call(location),
        );
      },
    );
  }
}

class _CustomExpansionTile extends StatefulWidget {
  final String location;
  final Map<String, dynamic>? data;
  final VoidCallback? onTap;

  const _CustomExpansionTile({
    required this.location,
    required this.data,
    this.onTap,
  });

  @override
  State<_CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => _expanded = !_expanded);
            if (_expanded) widget.onTap?.call();
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location name
                Expanded(
                  child: Text(
                    widget.location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                const SizedBox(width: 20),
                // Dropdown arrow
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          // If expanded show details, otherwise show nothing
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          // Call the LocationDetailsPanel with the data
          firstChild: LocationDetailsPanel(data: widget.data),
          // Empty when closed
          secondChild: const SizedBox.shrink(),
        ),
        // Add divider between items
        const Divider(
          color: Colors.white24,
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}
