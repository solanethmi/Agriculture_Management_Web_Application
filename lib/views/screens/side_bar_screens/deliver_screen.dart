import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliverScreen extends StatelessWidget {
  static const String routeName = '\DeliverScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliver Person Screen',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('deliverPersons').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var users = snapshot.data!.docs;

          return DataTable(
            columns: [
              DataColumn(label: Text('Email',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Full Name',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Phone Number',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Image',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            ],
            rows: users.map((user) {
              var userData = user.data() as Map<String, dynamic>;

              return DataRow(
                cells: [
                  DataCell(Text(userData['email'])),
                  DataCell(Text(userData['fullName'])),
                  DataCell(Text(userData['phoneNumber'])),
                  DataCell(
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData['profileImage']),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
