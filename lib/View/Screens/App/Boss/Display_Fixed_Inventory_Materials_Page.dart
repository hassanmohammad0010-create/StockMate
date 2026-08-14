import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class DisplayFixedInventoryMaterials extends StatelessWidget {
  DisplayFixedInventoryMaterials({super.key});
  final String pageName = '/DisplayFixedInventoryMaterials';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [CustomBackContainer()]));
  }
}
