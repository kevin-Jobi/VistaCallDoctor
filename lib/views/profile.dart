import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 210, 209, 209),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.grey),
                  SizedBox(width: 16),
                  Text('Name\nNajin', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 16),
                  Text('Experience\n12 years', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.phone_outlined, color: Colors.grey),
                  SizedBox(width: 16),
                  Text(
                    'Phone\n+91 80866 38332',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.mail, color: Colors.grey),
                  SizedBox(width: 16),
                  Text(
                    'Email\nnajin007@gmail.com',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.phone_outlined, color: Colors.grey),
                  SizedBox(width: 16),
                  Text(
                    'Category\ndermatologist',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.link_outlined, color: Colors.grey),
                  SizedBox(width: 16),
                  Text('Documents', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Add links',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
