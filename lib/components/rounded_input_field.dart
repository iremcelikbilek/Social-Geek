import 'package:flutter/material.dart';
import 'package:social_geek/components/text_field_container.dart';
import 'package:social_geek/constant.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final IconData icon;
  final ValueChanged<String> onSaved;
  const RoundedInputField({
    Key key,
    @required this.hintText,
    this.icon = Icons.person,
    @required this.onSaved,
    @required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          errorText: errorText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}