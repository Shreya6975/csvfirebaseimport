import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CSVToListConverterWidget extends StatefulWidget {
  @override
  _CSVToListConverterWidgetState createState() => _CSVToListConverterWidgetState();
}

class _CSVToListConverterWidgetState extends State<CSVToListConverterWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV to List Converter'),
        ),
        body: Text("data"));
  }

  Future<List<List<dynamic>>> readCsvData() async {
    final String csvString = await rootBundle.loadString('assets/data.csv');
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    return rowsAsListOfValues;
  }

  Future<void> uploadDataToFirebase(List<List<dynamic>> csvData) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

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
    final csvData = await readCsvData();
    await uploadDataToFirebase(csvData);
  }
}
