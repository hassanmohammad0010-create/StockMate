import 'package:flutter/material.dart';

class CustomHeadCard extends StatelessWidget {
   CustomHeadCard({super.key, required this.doctorName, required this.department});

  final String doctorName;
  final String department;


  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title:  Text(doctorName),
                subtitle:  Text(department),
              ),
            ),
          );
  }
}