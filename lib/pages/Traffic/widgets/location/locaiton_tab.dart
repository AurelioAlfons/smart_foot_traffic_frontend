import 'package:flutter/material.dart';

class LocationTab extends StatefulWidget {
  final List<String> locationNames;
  final Function(String) onTap;
  final List<dynamic> snapshotData;

  const LocationTab({
    super.key,
    required this.locationNames,
    required this.onTap,
    required this.snapshotData,
  });

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  String? expandedLocation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.locationNames.length,
      itemBuilder: (context, index) {
        final name = widget.locationNames[index];
        final isExpanded = expandedLocation == name;

        return Column(
          children: [
            Container(
              color: Colors.transparent,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(left: 16, bottom: 12),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  collapsedIconColor: Colors.white70,
                  iconColor: Colors.yellow[700],
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      expandedLocation = expanded ? name : null;
                      if (expanded) widget.onTap(name);
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildSnapshotPanel(name),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white30, height: 1, thickness: 1),
          ],
        );
      },
    );
  }

  Widget _buildSnapshotPanel(String locationName) {
    final snapshot = widget.snapshotData.firstWhere(
      (item) => item['location'] == locationName,
      orElse: () => null,
    );

    if (snapshot == null) {
      return const Text(
        "No data available.",
        style: TextStyle(color: Colors.white70),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow("Type", snapshot["traffic_type"]),
        _infoRow("Count", snapshot["count"].toString()),
        _infoRow("Date", snapshot["date"]),
        _infoRow("Time", snapshot["time"]),
        _infoRow("Season", snapshot["season"]),
        _infoRow("Weather", snapshot["weather"]),
        _infoRow("Temperature", snapshot["temperature"].toString()),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
