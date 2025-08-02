import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Import for platform checking
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/services/cloudinary_service.dart';
import 'map_picker_screen.dart';

final supabase = Supabase.instance.client;

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _reportAnonymously = false;

  XFile? _selectedImage; // Use XFile for cross-platform compatibility
  bool _isUploading = false;
  LatLng? _selectedLocation;
  String _locationAddress = "Tap to select location";
  bool _isFetchingLocation = false;

  final List<String> _categories = [
    'Streetlight', 'Road', 'Garbage Collection', 'Water Leakage', 'Public Transport', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() { _isFetchingLocation = true; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) throw Exception('Location permissions are permanently denied.');

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _locationAddress = "Location fetched!";
      });
    } catch (e) {
      setState(() { _locationAddress = "Could not fetch location"; });
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() { _isFetchingLocation = false; });
    }
  }

  Future<void> _navigateToMapPicker() async {
    final initialLoc = _selectedLocation ?? LatLng(28.644800, 77.216721);
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (context) => MapPickerScreen(initialLocation: initialLoc)),
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _locationAddress = 'Lat: ${result.latitude.toStringAsFixed(4)}, Lng: ${result.longitude.toStringAsFixed(4)}';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) setState(() { _selectedImage = pickedFile; });
  }

  Future<void> _submitIssue() async {
    if (_titleController.text.isEmpty || _selectedCategory == null || _descriptionController.text.isEmpty || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a location.')),
      );
      return;
    }

    setState(() { _isUploading = true; });

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        // Correctly call the uploadImage method from the service
        imageUrl = await CloudinaryService.uploadImage(_selectedImage!);
        if (imageUrl == null) throw Exception('Image upload failed.');
      }

      final userName = supabase.auth.currentUser?.userMetadata?['full_name'];

      await supabase.from('issues').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'image_url': imageUrl,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'is_anonymous': _reportAnonymously,
        'user_name': _reportAnonymously ? 'Anonymous' : userName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue reported successfully!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() { _isUploading = false; });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report New Issue'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: IgnorePointer(
        ignoring: _isUploading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: theme.dividerColor)),
                    child: _selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      // --- Cross-platform image preview ---
                      child: kIsWeb
                          ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                          : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                    )
                        : Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add_a_photo_outlined, size: 40, color: theme.iconTheme.color?.withOpacity(0.7)),
                        const SizedBox(height: 8),
                        Text('Add/Upload Photos', style: theme.textTheme.bodyLarge),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ... The rest of the UI remains the same ...

                Text('Location', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _navigateToMapPicker,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.dividerColor)),
                    child: Row(children: [
                      Icon(Icons.map_outlined, color: theme.iconTheme.color?.withOpacity(0.7)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_locationAddress, style: theme.textTheme.bodyLarge)),
                      if (_isFetchingLocation) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Issue Title', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Pothole on Main Road',
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Category', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.dividerColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      hint: const Text('Select a category'),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: _categories.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                      onChanged: (newValue) { setState(() { _selectedCategory = newValue; }); },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue in detail...',
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Report Anonymously'),
                  value: _reportAnonymously,
                  onChanged: (bool? value) { setState(() { _reportAnonymously = value ?? false; }); },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.blue,
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: ElevatedButton(
                    onPressed: _submitIssue,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: _isUploading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Text('Submit Issue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
