import 'package:flutter/material.dart';
import 'package:social_geek/components/text_field_container.dart';
import 'package:social_geek/constant.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final String initialText;
  final IconData icon;
  final Color cursorColor;
  final Color iconColor;
  final int maxLines;
  final bool readOnly;
  final TextInputType textInputType;
  final ValueChanged<String> onSaved;
  final FocusNode focusNode;
  const RoundedInputField({
    Key key,
    @required this.hintText,
    this.focusNode,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputType = TextInputType.emailAddress,
    this.cursorColor = kPrimaryColor,
    this.iconColor = kPrimaryColor,
    this.icon = Icons.person,
    this.initialText,
    @required this.onSaved,
    @required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        focusNode: focusNode,
        readOnly: readOnly,
        maxLines: maxLines,
        initialValue: initialText,
        keyboardType: textInputType,
        onSaved: onSaved,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          hintText: hintText,
          errorText: errorText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}