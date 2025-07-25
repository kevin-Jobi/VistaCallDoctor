// views/profile/components/profile_header.dart
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileHeader({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 196, 223, 241),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: const Text('Dr. Najin'),
        subtitle: const Text('Cardiologist'),
        onTap: onTap,
      ),
    );
  }
}