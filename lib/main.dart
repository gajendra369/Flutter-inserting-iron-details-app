import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_ins/list.dart';

import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      home: HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _navigateToListPage(context);
            },
          ),
        ],
      ),
      body: AddLocationScreen(), // Use AddLocationScreen as body
    );
  }

  void _navigateToListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationListScreen()),
    );
  }
}

class AddLocationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ironContentController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: ironContentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Iron Content'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveLocation(context);
              },
              child: Text('Save Location'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveLocation(BuildContext context) async {
    String name = nameController.text;
    double ironContent = double.parse(ironContentController.text);
    double latitude = double.parse(latitudeController.text);
    double longitude = double.parse(longitudeController.text);

    await databaseReference.child('locations').push().set({
      'name': name,
      'iron_content': ironContent,
      'latitude': latitude,
      'longitude': longitude,
    });

    // Clear text fields after saving
    nameController.clear();
    ironContentController.clear();
    latitudeController.clear();
    longitudeController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Location saved successfully!'),
    ));
  }
}
