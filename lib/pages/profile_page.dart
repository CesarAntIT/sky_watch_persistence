import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sky_watch/Model/profile_model.dart';
import 'package:sky_watch/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Profile profile;

  @override
  void initState() {
    profile = objectbox.getCurrentProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image(image: FileImage(File(profile.imagePath))),
              ),
              Text(
                "${profile.name} ${profile.lastName}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight(700)),
              ),
              Text(profile.studentId, style: TextStyle(fontSize: 20)),
              Text(
                profile.phrase,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
