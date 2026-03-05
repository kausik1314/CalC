import 'package:flutter/material.dart';

class CalculatorLogic extends ChangeNotifier {
  String _currentInput = '0';
  String _previousInput = '';
  String _operator = '';
  bool _shouldResetInput = false;

  String get currentInput => _currentInput;
  String get previousInput => _previousInput;
  String get operator => _operator;

  void onButtonPressed(String text) {
    if (text == 'C') {
      clear();
    } else if (text == '⌫') {
      backspace();
    } else if (text == '=') {
      calculate();
    } else if (text == '%') {
      calculatePercentage();
    } else if (text == '±') {
      toggleSign();
    } else if (['+', '−', '×', '÷'].contains(text)) {
      setOperator(text);
    } else {
      appendNumber(text);
    }
  }

  void clear() {
    _currentInput = '0';
    _previousInput = '';
    _operator = '';
    _shouldResetInput = false;
    notifyListeners();
  }

  void backspace() {
    if (_shouldResetInput) return;
    if (_currentInput.length > 1) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    } else {
      _currentInput = '0';
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_currentInput == '0' || _shouldResetInput) return;
    if (_currentInput.startsWith('-')) {
      _currentInput = _currentInput.substring(1);
    } else {
      _currentInput = '-' + _currentInput;
    }
    notifyListeners();
  }

  void appendNumber(String numString) {
    if (_shouldResetInput) {
      _currentInput = numString;
      if (numString == '.') _currentInput = '0.';
      _shouldResetInput = false;
    } else {
      if (_currentInput == '0' && numString != '.') {
        _currentInput = numString;
      } else if (numString == '.' && _currentInput.contains('.')) {
        return; 
      } else {
        _currentInput += numString;
      }
    }
    notifyListeners();
  }

  void setOperator(String op) {
    if (_operator.isNotEmpty && !_shouldResetInput) {
      calculate();
    }
    _previousInput = _currentInput;
    _operator = op;
    _shouldResetInput = true;
    notifyListeners();
  }

  void calculatePercentage() {
    double? current = double.tryParse(_currentInput);
    if (current != null) {
      _currentInput = (current / 100).toString();
      _formatOutput();
      notifyListeners();
    }
  }

  void calculate() {
    if (_operator.isEmpty || _previousInput.isEmpty) return;
    double? num1 = double.tryParse(_previousInput);
    double? num2 = double.tryParse(_currentInput);
    if (num1 == null || num2 == null) return;

    double result = 0;
    switch (_operator) {
      case '+': result = num1 + num2; break;
      case '−': result = num1 - num2; break;
      case '×': result = num1 * num2; break;
      case '÷':
        if (num2 == 0) {
          _currentInput = 'Error';
          _operator = '';
          _previousInput = '';
          _shouldResetInput = true;
          notifyListeners();
          return;
        }
        result = num1 / num2; break;
    }
    _currentInput = result.toString();
    _formatOutput();
    _previousInput = '';
    _operator = '';
    _shouldResetInput = true;
    notifyListeners();
  }

  void _formatOutput() {
    if (_currentInput.endsWith('.0')) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 2);
    } else if (_currentInput.contains('.') && _currentInput.length > 10) {
      double parsed = double.parse(_currentInput);
      _currentInput = parsed.toStringAsPrecision(8).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (_currentInput.endsWith('.')) _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    }
  }
}
