import 'package:flutter/material.dart';
import 'package:social_geek/components/text_field_container.dart';
import 'package:social_geek/constant.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onSaved;
  final String errorText;
  const RoundedPasswordField({
    Key key,
    @required this.onSaved,
    @required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          errorText: errorText,
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}