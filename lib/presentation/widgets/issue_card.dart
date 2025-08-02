import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lidar/app/models/issue_model.dart';
import '../screens/issue_details_screen.dart'; // Import the new details screen

class IssueCard extends StatefulWidget {
  final Issue issue;
  final LatLng? currentUserLocation;

  const IssueCard({
    super.key,
    required this.issue,
    this.currentUserLocation,
  });

  @override
  State<IssueCard> createState() => _IssueCardState();
}

class _IssueCardState extends State<IssueCard> {
  String _address = 'Loading location...';
  String _distance = '';

  @override
  void initState() {
    super.initState();
    _getAddressAndDistance();
  }

  @override
  void didUpdateWidget(covariant IssueCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.issue.id != oldWidget.issue.id || widget.currentUserLocation != oldWidget.currentUserLocation) {
      _getAddressAndDistance();
    }
  }

  Future<void> _getAddressAndDistance() async {
    if (widget.issue.latitude == null || widget.issue.longitude == null) {
      if (mounted) setState(() => _address = 'Location not available');
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(widget.issue.latitude!, widget.issue.longitude!);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _address = "${p.street ?? p.subLocality ?? ''}, ${p.locality ?? ''}";
      } else {
        _address = "Address not found";
      }
    } catch (e) {
      _address = "Could not get address";
    }

    if (widget.currentUserLocation != null) {
      const distance = Distance();
      final km = distance.as(LengthUnit.Kilometer, widget.currentUserLocation!, LatLng(widget.issue.latitude!, widget.issue.longitude!));
      _distance = "${km.toStringAsFixed(1)} km";
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final darkCardColor = Colors.grey[900];
    final primaryTextColor = Colors.white;
    final secondaryTextColor = Colors.grey[400];

    return GestureDetector(
      onTap: () {
        Get.to(() => IssueDetailsScreen(issue: widget.issue));
      },
      child: Card(
        color: darkCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Allow card to fit content
          children: [
            // --- Image Section with Overlays ---
            Stack(
              children: [
                widget.issue.imageUrl != null
                    ? Image.network(
                  widget.issue.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 180,
                      color: Colors.grey[850],
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  },
                )
                    : _buildImagePlaceholder(),
                // Status Chip (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Chip(
                    label: Text(
                      '${widget.issue.status} • ${widget.issue.formattedDate}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    backgroundColor: widget.issue.statusColor.withOpacity(0.9),
                    avatar: const Icon(Icons.circle, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            // --- Text Content Section ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.issue.title ?? widget.issue.category,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Chip(
                        label: Text(widget.issue.category, style: TextStyle(color: Colors.white.withOpacity(0.9))),
                        backgroundColor: Colors.black.withOpacity(0.5),
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                      // Text(widget.issue.category, style: TextStyle(color: Colors.deepOrangeAccent)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.issue.description,
                    style: TextStyle(fontSize: 14, height: 1.4, color: secondaryTextColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3, // Allow more lines for description
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: secondaryTextColor, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _address,
                          style: TextStyle(color: secondaryTextColor, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_distance.isNotEmpty)
                        Text(
                          '~$_distance',
                          style: TextStyle(color: secondaryTextColor, fontSize: 12),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      color: Colors.grey[850],
      child: Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey[600], size: 40),
      ),
    );
  }
}
