import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
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
      title: 'CSV to Firebase',
      home: CSVToFirebaseScreen(),
    );
  }
}

class CSVToFirebaseScreen extends StatelessWidget {
  Future<List<List<dynamic>>> readCsvData() async {
    debugPrint("789");

    final String csvString = await rootBundle.loadString('assets/data.csv');
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    return rowsAsListOfValues;
  }

  Future<void> uploadDataToFirebase(List<List<dynamic>> csvData) async {
    debugPrint("741");

    final DatabaseReference databaseReference =  FirebaseDatabase.instance.reference().child("users");

    for (final row in csvData) {
      // Assuming your CSV columns are organized as: column1, column2, column3
      final String column1Value = row[0];
      final String column2Value = row[1];
      final String column3Value = row[2];

      final newEntry = <String, dynamic>{
        'column1': column1Value,
        'column2': column2Value,
        'column3': column3Value,
      };

      await databaseReference.push().set(newEntry);
    }
  }

  Future<void> importCsvAndUpload() async {
    debugPrint("456");
    final csvData = await readCsvData();
    await uploadDataToFirebase(csvData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV to List Converter'),
        ),
        body: Center(
          child: InkWell(
              onTap: () {
                debugPrint("123");
                importCsvAndUpload();
              },
              child: Text("data")),
        ));
  }
}
