import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: constColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: constColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
