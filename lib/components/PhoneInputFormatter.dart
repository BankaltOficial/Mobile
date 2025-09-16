import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Classe para formatação de telefone
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (text.length > 11) {
      text = text.substring(0, 11);
    }
    
    String formatted = '';
    
    if (text.length > 0) {
      formatted = '(${text.substring(0, text.length > 2 ? 2 : text.length)}';
      
      if (text.length > 2) {
        formatted += ') ${text.substring(2, text.length > 7 ? 7 : text.length)}';
        
        if (text.length > 7) {
          formatted += '-${text.substring(7)}';
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}