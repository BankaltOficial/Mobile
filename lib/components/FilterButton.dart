// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.main : AppColors.mainWhite,
        foregroundColor: isSelected ? AppColors.mainWhite : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        side: BorderSide(color: AppColors.main),
      ),
      child: Text(text),
    );
  }
}
