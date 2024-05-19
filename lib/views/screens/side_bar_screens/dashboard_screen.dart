import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/DashboardScreen';

  Widget _dashboardCard(String collectionName, IconData icon, String title) {
    return Expanded(
      child: Container(
        height: 140,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 8, 8, 8)),
          color: Color.fromARGB(255, 238, 210, 145),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            SizedBox(height: 5),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                int count = snapshot.data?.size ?? 0;

                return Text(
                  '$count',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 15, 14, 14),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              },
            ),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 15, 14, 14),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/a-bg.jpg"),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(18),
              child: const Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Row(
              children: [
                _dashboardCard('buyers', Icons.person, 'Buyers,'),
                SizedBox(width: 25),
                _dashboardCard('vendors', Icons.store, 'Vendors'),
                SizedBox(width: 25),
                _dashboardCard('deliverPersons', Icons.delivery_dining, 'Delivery Persons'),
                SizedBox(width: 25),
                _dashboardCard('pricechart', Icons.attach_money, 'Price Chart Products'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
