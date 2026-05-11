import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomTextFormFaild extends StatefulWidget {
  final String labelText;
  final Icon? icon;
  Function(String)? onChange;
  String? Function(String?)? validator;
  String? hintText;
  IconButton? suffixIcon;
  String? initialValue;
  int? maxLenght;

  TextInputType? textInputType = TextInputType.text;
  bool? obscureText = false;
  int? maxLine;

  CustomTextFormFaild({
    super.key,
    this.maxLine,
    required this.labelText,
    this.icon,
    this.obscureText,
    this.hintText,
    this.maxLenght,
    required this.onChange,
    required this.validator,
    this.suffixIcon,
    this.initialValue,
    this.textInputType,
  });

  @override
  State<CustomTextFormFaild> createState() => _CustomTextFormFaildState();
}

class _CustomTextFormFaildState extends State<CustomTextFormFaild> {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        maxLines: widget.obscureText == null ? widget.maxLine : 1,
        maxLength: widget.maxLenght,
        keyboardType: widget.textInputType,

        initialValue: widget.initialValue,
        obscureText: widget.obscureText ?? false,
        validator: widget.validator,

        onChanged: widget.onChange,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.icon,

          prefixIconColor: constColor,
          label: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              widget.labelText,
              style: TextStyle(
                fontSize: 28,
                fontFamily: lateef,
                color: constGray,
              ),
            ),
          ),
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
      ),
    );
  }
}
