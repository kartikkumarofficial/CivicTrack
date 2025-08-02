import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lidar/app/models/issue_model.dart';
import 'issue_details_screen.dart';

final supabase = Supabase.instance.client;

class IssuesMapScreen extends StatefulWidget {
  const IssuesMapScreen({super.key});

  @override
  State<IssuesMapScreen> createState() => _IssuesMapScreenState();
}

class _IssuesMapScreenState extends State<IssuesMapScreen> {
  late final Future<List<Issue>> _issuesFuture;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _issuesFuture = _fetchIssuesWithLocation();
  }

  // --- Fetch all issues that have a location from Supabase ---
  Future<List<Issue>> _fetchIssuesWithLocation() async {
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('issues')
          .select()
          .not('latitude', 'is', null)
          .not('longitude', 'is', null);

      return data.map((map) => Issue.fromMap(map)).toList();
    } catch (e) {
      // Handle error gracefully
      print("Error fetching issues for map: $e");
      return [];
    }
  }

  // --- Helper to get a specific icon for each category ---
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Streetlight':
        return Icons.lightbulb_outline;
      case 'Road':
        return Icons.edit_road_outlined;
      case 'Garbage Collection':
        return Icons.delete_outline;
      case 'Water Leakage':
        return Icons.water_drop_outlined;
      case 'Public Transport':
        return Icons.directions_bus_outlined;
      default:
        return Icons.report_problem_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues Map'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Issue>>(
        future: _issuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No issues with location data found.'));
          }

          final issues = snapshot.data!;

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // Default center to the first issue or a fallback location
              initialCenter: LatLng(issues.first.latitude!, issues.first.longitude!),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: isDarkMode
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app', // Replace with your package name
              ),
              // --- Layer for all the issue markers ---
              MarkerLayer(
                markers: issues.map((issue) {
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(issue.latitude!, issue.longitude!),
                    child: GestureDetector(
                      onTap: () {
                        // Show a small popup with issue info
                        _showIssueInfoPopup(context, issue);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: issue.statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, spreadRadius: 1),
                          ],
                        ),
                        child: Icon(
                          _getIconForCategory(issue.category),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Function to show the info pop-up on marker tap ---
  void _showIssueInfoPopup(BuildContext context, Issue issue) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: 280,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Image and Title Row ---
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: issue.imageUrl != null
                          ? Image.network(
                        issue.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => const Icon(Icons.image_not_supported, size: 80),
                      )
                          : Container(width: 80, height: 80, color: Colors.grey[300], child: const Icon(Icons.image, size: 40)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.title ?? issue.category,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            issue.category,
                            style: TextStyle(color: issue.statusColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // --- View Details Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet first
                      Get.to(() => IssueDetailsScreen(issue: issue));
                    },
                    child: const Text('View Details', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
