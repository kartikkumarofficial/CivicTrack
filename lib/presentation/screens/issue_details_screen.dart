import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lidar/app/models/issue_model.dart';

class IssueDetailsScreen extends StatelessWidget {
  final Issue issue;

  const IssueDetailsScreen({super.key, required this.issue});

  // Helper to launch Google Maps
  Future<void> _launchMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- App Bar with Collapsing Image ---
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            iconTheme: theme.iconTheme,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              title: Text(
                issue.title ?? issue.category,
                style: GoogleFonts.poppins(
                  color: theme.textTheme.titleLarge?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: issue.imageUrl != null
                  ? Image.network(
                issue.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(theme),
              )
                  : _buildImagePlaceholder(theme),
            ),
          ),
          // --- Details Content ---
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Status and Date Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(issue.category, style: GoogleFonts.lato()),
                          backgroundColor: theme.colorScheme.surface.withOpacity(isDarkMode ? 1.0 : 0.7),
                        ),
                        Chip(
                          avatar: const Icon(Icons.circle, color: Colors.white, size: 12),
                          label: Text(
                            '${issue.status} • ${issue.formattedDate}',
                            style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: issue.statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Description Section ---
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      issue.description,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        height: 1.5,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 16),

                    // --- Reporter Info ---
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        issue.isAnonymous ? Icons.visibility_off_outlined : Icons.person_outline,
                        color: theme.iconTheme.color,
                      ),
                      title: Text(
                        'Reported by',
                        style: GoogleFonts.lato(color: theme.textTheme.bodySmall?.color),
                      ),
                      subtitle: Text(
                        issue.isAnonymous ? 'Anonymous' : (issue.userName ?? 'N/A'),
                        style: GoogleFonts.poppins(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Map View Section ---
                    Text(
                      'Location',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (issue.latitude != null && issue.longitude != null)
                      SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(issue.latitude!, issue.longitude!),
                              initialZoom: 15.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: isDarkMode
                                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.app', // Replace with your package name
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(issue.latitude!, issue.longitude!),
                                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Text('Location data not available.'),
                    const SizedBox(height: 8),
                    if (issue.latitude != null && issue.longitude != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.directions),
                          label: Text('Get Directions', style: GoogleFonts.lato()),
                          onPressed: () => _launchMaps(issue.latitude!, issue.longitude!),
                        ),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface.withOpacity(0.5),
      child: Center(
        child: Icon(Icons.image_not_supported, color: theme.iconTheme.color?.withOpacity(0.5), size: 50),
      ),
    );
  }
}
