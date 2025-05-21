import 'package:flutter/material.dart';

class LocationTab extends StatelessWidget {
  final Map<String, dynamic>? snapshotData;
  final void Function(String locationName)? onLocationTap;

  const LocationTab({
    super.key,
    required this.snapshotData,
    required this.onLocationTap,
  });

  final List<String> allLocations = const [
    "Footscray Library Car Park",
    "Footscray Market Hopkins And Irving",
    "Footscray Market Hopkins And Leeds",
    "Footscray Market Irving St Train Stn",
    "Footscray Park Gardens",
    "Footscray Park Rowing Club",
    "Nic St Campus",
    "Nicholson Mall Clock Tower",
    "Salt Water Child Care Centre",
    "Snap Fitness",
    "West Footscray Library",
  ];

  @override
  Widget build(BuildContext context) {
    final sortedLocations = [...allLocations]..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      itemCount: sortedLocations.length,
      itemBuilder: (context, index) {
        final location = sortedLocations[index];
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
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.yellow[700],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _buildDetails(widget.data),
          secondChild: const SizedBox.shrink(),
        ),
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

  Widget _buildDetails(Map<String, dynamic>? data) {
    if (data == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "No data available.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final rawTime = data['time']?.toString() ?? '';
    final timeDisplay = rawTime.isNotEmpty ? _formatTimeRange(rawTime) : 'N/A';

    final temp = data['temperature'];
    final temperatureDisplay = temp != null ? "$temp°C" : 'N/A';

    return Column(
      children: [
        _info(
            Icons.directions_car, "Type", data['traffic_type'] ?? data['type']),
        _info(Icons.confirmation_number, "Count", data['count']),
        _info(Icons.calendar_today, "Date", data['date']),
        _info(Icons.access_time, "Time", timeDisplay),
        _info(Icons.park, "Season", data['season']),
        _info(Icons.cloud, "Weather", data['weather']),
        _info(Icons.thermostat, "Temperature", temperatureDisplay),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _info(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              "$title:",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(String time) {
    try {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final nextHour = (hour + 1) % 24;
      return "${hour.toString().padLeft(2, '0')}:00 – ${nextHour.toString().padLeft(2, '0')}:00";
    } catch (_) {
      return time;
    }
  }
}
