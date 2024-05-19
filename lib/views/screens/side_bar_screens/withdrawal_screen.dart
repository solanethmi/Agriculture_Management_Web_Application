import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendor Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
         );
  }
}

class VendorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          var vendors = snapshot.data!.docs;

          return DataTable(
            columns: [
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Phone Number')),
              DataColumn(label: Text('Image')),
            ],
            rows: List<DataRow>.generate(
              vendors.length,
              (index) {
                var vendor = vendors[index].data() as Map<String, dynamic>;
                var email = vendor['email'] as String?;
                var fullName = vendor['fullName'] as String?;
                var phoneNumber = vendor['phoneNumber'] as String?;
                var imageBytes = vendor['image'] as Uint8List?;

                return DataRow(
                  cells: [
                    DataCell(Text(email ?? '')),
                    DataCell(Text(fullName ?? '')),
                    DataCell(Text(phoneNumber ?? '')),
                    DataCell(imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container()),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
