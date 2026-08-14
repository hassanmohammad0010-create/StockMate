import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

// ignore: must_be_immutable
class DisplayConsunbleInventoryMaterials extends StatelessWidget {
  DisplayConsunbleInventoryMaterials({super.key});
  final String pageName = '/DisplayConsunbleInventoryMaterials';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [CustomBackContainer()]));
  }
}
