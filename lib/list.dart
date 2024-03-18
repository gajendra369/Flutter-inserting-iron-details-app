import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({Key? key}) : super(key: key);

  @override
  LocationListScreenState createState() => LocationListScreenState();
}

class LocationListScreenState extends State<LocationListScreen> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    DataSnapshot dataSnapshot = (await databaseReference.child('locations').once()).snapshot;
    List<Map<String, dynamic>> newLocations = [];
    if (dataSnapshot.value != null && dataSnapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;


      values.forEach((key, value) {
        if (value is Map<Object?, Object?>) { // Adjust type check
          Map<Object?, Object?> mapValue = value;
          // Now you can safely access the mapValue and its contents
          // Remember to cast the keys and values to the appropriate types if necessary
          if (mapValue.containsKey('name') &&
              mapValue.containsKey('iron_content') &&
              mapValue.containsKey('latitude') &&
              mapValue.containsKey('longitude')) {
            Map<String, dynamic> location = {
              'key': key,
              'name': mapValue['name'],
              'iron_content': mapValue['iron_content'],
              'latitude': mapValue['latitude'],
              'longitude': mapValue['longitude'],
            };
            newLocations.add(location);
          }
        }
      });
      setState(() {
        locations = newLocations;
      });
    }
  }


  Future<void> _deleteLocation(String key) async {
    await databaseReference.child('locations').child(key).remove();
    print("Item deleted. Fetching updated locations...");
    setState(() {
      locations.removeWhere((location) => location['key'] == key);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location List'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(locations[index]['name']),
            subtitle: Text('Iron Content: ${locations[index]['iron_content']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteLocation(locations[index]['key']);
              },
            ),
          );
        },
      ),
    );
  }
}
