import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Issue {
  final int id;
  final DateTime createdAt;
  final String? title; // Added title
  final String description;
  final String category;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final bool isAnonymous;
  final String status;
  final String? userId;
  final String? userName; // Added user's name

  Issue({
    required this.id,
    required this.createdAt,
    this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    this.latitude,
    this.longitude,
    required this.isAnonymous,
    required this.status,
    this.userId,
    this.userName,
  });

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'], // Parse new title field
      description: map['description'] ?? 'No description',
      category: map['category'] ?? 'Uncategorized',
      imageUrl: map['image_url'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isAnonymous: map['is_anonymous'] ?? false,
      status: map['status'] ?? 'Reported',
      userId: map['user_id'],
      userName: map['user_name'], // Parse new user_name field
    );
  }

  String get formattedDate {
    return DateFormat('MMM dd').format(createdAt);
  }

  Color get statusColor {
    switch (status) {
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'Reported':
      default:
        return Colors.pink;
    }
  }
}
