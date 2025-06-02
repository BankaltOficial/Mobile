import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';

class RadioUtils {
  static Widget buildRadioOption(String title, String? groupValue, Function(String?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        value: title,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.main,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}