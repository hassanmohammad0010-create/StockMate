// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class TextFormFaildForDate extends StatefulWidget {
  final String labelText;
  final Icon? icon;
  Function(String)? onChange;
  String? Function(String?)? validator;
  String? hintText;
  IconButton? suffixIcon;
  String? initialValue;
  int? maxLenght;
  TextEditingController? textEditingController;
  TextInputType? textInputType = TextInputType.text;
  bool? obscureText = false, readOnly;
  int? maxLine;
  VoidCallback? onTap;
  TextFormFaildForDate({
    super.key,
    this.maxLine,
    required this.labelText,
    this.onTap,
    this.icon,
    this.obscureText,
    this.hintText,
    this.maxLenght,
    required this.onChange,
    required this.validator,
    this.suffixIcon,
    this.textEditingController,
    this.initialValue,
    this.textInputType,
    this.readOnly,
  });

  @override
  State<TextFormFaildForDate> createState() => _TextFormFaildForDateState();
}

class _TextFormFaildForDateState extends State<TextFormFaildForDate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.04,
        vertical: context.screenHeight * 0.01,
      ),
      child: TextFormField(
        controller: widget.textEditingController,
        onTap: widget.onTap,
        readOnly: widget.readOnly ?? false,
        maxLines: widget.obscureText == null ? widget.maxLine : 1,
        maxLength: widget.maxLenght,
        keyboardType: widget.textInputType,
        initialValue: widget.initialValue,
        obscureText: widget.obscureText ?? false,
        validator: widget.validator,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.icon,
          prefixIconColor: Colors.grey.shade600,
          hint: Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 24,
              fontFamily: lateef,
              color: Colors.grey.shade600,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}
