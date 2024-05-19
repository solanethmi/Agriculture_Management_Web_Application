import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  static const String routeName = '/PriceChartScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PriceChartScreen(),
    );
  }
}

class PriceChartScreen extends StatefulWidget {
  static const String routeName = '/PriceChartScreen';

  @override
  _PriceChartScreenState createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends State<PriceChartScreen> {
  List<Map<String, dynamic>> rows = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Fetch initial records when the screen is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Chart'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Product Name')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Average Price')),
            DataColumn(label: Text('Actions')),
          ],
          rows: [
            ...List<DataRow>.generate(
              rows.length,
              (index) {
                return _buildDataRow(index);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRow();
        },
        tooltip: 'Add Row',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _saveRecords();
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateRecords();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(rows[index]['productName'].toString()),
        ),
        DataCell(
          Text(rows[index]['quantity'].toString()),
        ),
        DataCell(
          Text(rows[index]['averagePrice'].toString()),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editRow(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteRow(index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addRow() {
    setState(() {
      rows.add({});
    });
  }

  void _editRow(int index) async {
    var result = await showDialog(
      context: context,
      builder: (context) => EditRowDialog(initialData: rows[index]),
    );

    if (result != null) {
      setState(() {
        rows[index] = result;
        _updateRecordInFirestore(rows[index]);
      });
    }
  }

  void _deleteRow(int index) {
    setState(() {
      _removeRecordFromFirestore(rows[index]);
      rows.removeAt(index);
    });
  }

  void _saveRecords() async {
    try {
      await FirebaseFirestore.instance.collection('pricechart').add({
        'records': rows,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Directly add the saved row to the local list
      rows.add({}); // You can replace this with the actual data you want to add
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Records saved successfully!'),
        ),
      );
    } catch (e) {
      print('Error saving records: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving records. Please try again.'),
        ),
      );
    }
  }

  void _updateRecords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pricechart').get();
      List<Map<String, dynamic>> fetchedRows = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        fetchedRows = List.from(data['records']);
      });

      // Show a dialog with the fetched records in a table
      showDialog(
        context: context,
        builder: (context) => RecordsTableDialog(records: fetchedRows),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Records updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating records: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating records. Please try again.'),
        ),
      );
    }
  }

  void _fetchRecords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pricechart').get();
      List<Map<String, dynamic>> fetchedRows = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        fetchedRows = List.from(data['records']);
      });

      setState(() {
        rows = fetchedRows;
      });
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  void _updateRecordInFirestore(Map<String, dynamic> record) async {
    try {
      // Identify the document ID based on the record (you may need to modify this logic)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pricechart').get();
      String? docId;

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['records'].contains(record)) {
          docId = doc.id;
        }
      });

      // Update the record in Firestore
      if (docId != null) {
        await FirebaseFirestore.instance.collection('pricechart').doc(docId).update({
          'records': FieldValue.arrayUnion([record]),
        });
      }
    } catch (e) {
      print('Error updating record in Firestore: $e');
    }
  }

  void _removeRecordFromFirestore(Map<String, dynamic> record) async {
    try {
      // Identify the document ID based on the record (you may need to modify this logic)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pricechart').get();
      String? docId;

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['records'].contains(record)) {
          docId = doc.id;
        }
      });

      // Remove the record from Firestore
      if (docId != null) {
        await FirebaseFirestore.instance.collection('pricechart').doc(docId).update({
          'records': FieldValue.arrayRemove([record]),
        });
      }
    } catch (e) {
      print('Error removing record from Firestore: $e');
    }
  }
}

class EditRowDialog extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditRowDialog({Key? key, required this.initialData}) : super(key: key);

  @override
  _EditRowDialogState createState() => _EditRowDialogState();
}

class _EditRowDialogState extends State<EditRowDialog> {
  late TextEditingController productNameController;
  late TextEditingController quantityController;
  late TextEditingController averagePriceController;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: widget.initialData['productName'] ?? '');
    quantityController = TextEditingController(text: widget.initialData['quantity']?.toString() ?? '');
    averagePriceController = TextEditingController(text: widget.initialData['averagePrice']?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Row'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: averagePriceController,
            decoration: InputDecoration(labelText: 'Average Price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'productName': productNameController.text,
              'quantity': int.tryParse(quantityController.text) ?? 0,
              'averagePrice': double.tryParse(averagePriceController.text) ?? 0.0,
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class RecordsTableDialog extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  const RecordsTableDialog({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Records Table-(Price Chart)',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Product Name',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Quantity',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Average Price',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
          ],
          rows: [
            ...records.map((record) {
              return DataRow(
                cells: [
                  DataCell(Text(record['productName'].toString())),
                  DataCell(Text(record['quantity'].toString())),
                  DataCell(Text(record['averagePrice'].toString())),
                ],
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
