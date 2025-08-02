import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lidar/app/models/issue_model.dart';
import '../widgets/issue_card.dart';
import 'report_issue_screen.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<List<Issue>> _issuesStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showMyIssues = false;
  LatLng? _currentUserLocation;

  @override
  void initState() {
    super.initState();
    _setupIssuesStream();
    _getCurrentLocation();
  }

  void _setupIssuesStream() {
    _issuesStream = supabase
        .from('issues')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((listOfMaps) {
      return listOfMaps.map((map) => Issue.fromMap(map)).toList();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      print("Could not get location: $e");
    }
  }

  void _toggleMyIssuesFilter() {
    setState(() {
      _showMyIssues = !_showMyIssues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CivicTrack'),
        actions: [
          IconButton(
            icon: Icon(
              _showMyIssues ? Icons.person : Icons.group,
              color: _showMyIssues ? Theme.of(context).colorScheme.secondary : null,
            ),
            tooltip: _showMyIssues ? "Show All Issues" : "Show My Issues",
            onPressed: _toggleMyIssuesFilter,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() { _searchQuery = value; }),
                decoration: InputDecoration(
                  hintText: 'Search Issues...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Issue>>(
                stream: _issuesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No issues reported yet.'));
                  }

                  List<Issue> issues = snapshot.data!;
                  if (_showMyIssues) {
                    final currentUserId = supabase.auth.currentUser?.id;
                    if (currentUserId != null) {
                      issues = issues.where((issue) => issue.userId == currentUserId).toList();
                    }
                  }
                  if (_searchQuery.isNotEmpty) {
                    issues = issues.where((issue) =>
                    (issue.title?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
                        issue.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        issue.category.toLowerCase().contains(_searchQuery.toLowerCase())
                    ).toList();
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 600;
                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 80),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 2 : 1,
                          // Adjusted aspect ratio to give the card more height
                          childAspectRatio: isDesktop ? 2.4 : 1.1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: issues.length,
                        itemBuilder: (context, index) => IssueCard(
                          issue: issues[index],
                          currentUserLocation: _currentUserLocation,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const ReportIssueScreen());
        },
        label: const Text('New Issue'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
