import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    required this.buttonTitle,
    required this.onTap,
    required this.iconBackgroundColor,
    required this.buttonColor,
  });

  final Icon icon;
  final String number;
  final String title;
  final String buttonTitle;
  final VoidCallback onTap;
  final Color iconBackgroundColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.48,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Card(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                  SizedBox(width: 20),
                  Text(number, style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.38,
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 20,
              child: MaterialButton(
                onPressed: onTap,
                child: Text(
                  buttonTitle,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
