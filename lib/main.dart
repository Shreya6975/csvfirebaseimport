import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('CSV to Firestore')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              List<List<dynamic>> csvData = await parseCSV();
              await addDataToFirestore(csvData);
              print('Data added to Firestore');
            },
            child: Text('Upload CSV to Firestore'),
          ),
        ),
      ),
    );
  }

  Future<List<List<dynamic>>> parseCSV() async {
    final String data = await rootBundle.loadString('assets/data.csv');
    final List<List<dynamic>> csvTable = CsvToListConverter().convert(data);
    return csvTable;
  }

  Future<void> addDataToFirestore(List<List<dynamic>> csvData) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection('user');

    for (var row in csvData) {
      final Map<String, dynamic> data = {
        'author_name': row[0],
        'chapter': row[1],
        'chapter_image': row[2],
        'chapter_name': row[3],
        'subject_id': row[4],
      };

      await collection.add(data);
    }
  }
}
