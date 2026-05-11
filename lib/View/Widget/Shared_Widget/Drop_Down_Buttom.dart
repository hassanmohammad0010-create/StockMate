import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    super.key,
    required this.itemList,
    required this.hintText,
    required this.icon,
    this.selectedItem,
    this.enabled,
    this.label,
    required this.onChanched,
  });
  List<String> itemList;
  String? selectedItem;
  Icon icon;
  String? label;
  bool? enabled;
  String hintText;
  Function(String? data) onChanched;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: DropdownButtonFormField<String>(
        menuMaxHeight: 400,

        alignment: AlignmentGeometry.centerRight,

        isExpanded: true,
        initialValue: selectedItem,
        validator: (value) {
          if (value == null && !itemList.contains(selectedItem)) {
            return 'الحقل ضروري';
          }
          return null;
        },
        iconEnabledColor: constColor,
        style: TextStyle(fontFamily: lateef, fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: icon,
          ),

          prefixIconColor: constColor,
          label: label != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: Text(
                    label!,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: lateef,
                      color: constGray,
                    ),
                  ),
                )
              : null,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: constGray, width: 1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.all(22),
        ),
        hint: Text(
          hintText,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: lateef, fontSize: 28, color: constGray),
        ),
        items: itemList
            .map(
              (item) => DropdownMenuItem(
                alignment: Alignment.center,
                enabled: enabled ?? true,

                value: item,
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: lateef,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanched,
      ),
    );
  }
}
