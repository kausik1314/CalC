import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class HistoryItem {
  final String equation;
  final String result;
  HistoryItem(this.equation, this.result);
}

class CalculatorLogic extends ChangeNotifier {
  String _currentInput = '0';
  String _previousInput = '';
  String _operator = '';
  bool _shouldResetInput = false;
  
  final List<HistoryItem> _history = [];

  String get currentInput => _currentInput;
  String get previousInput => _previousInput;
  String get operator => _operator;
  List<HistoryItem> get history => _history;

  void onButtonPressed(String text) {
    HapticFeedback.lightImpact(); 

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
    } else if (['sin', 'cos', 'tan', 'log', 'ln', '√', 'x²'].contains(text)) {
      applyScientific(text);
    } else if (text == 'π') {
      appendNumber(math.pi.toString());
      _shouldResetInput = true;
    } else if (text == 'e') {
      appendNumber(math.e.toString());
      _shouldResetInput = true;
    } else {
      appendNumber(text);
    }
  }

  void applyScientific(String func) {
    double? current = double.tryParse(_currentInput);
    if (current == null) return;
    
    double result = 0;
    String equationPrefix = '';
    switch (func) {
      case 'sin': result = math.sin(current * (math.pi / 180)); equationPrefix = 'sin'; break; 
      case 'cos': result = math.cos(current * (math.pi / 180)); equationPrefix = 'cos'; break;
      case 'tan': result = math.tan(current * (math.pi / 180)); equationPrefix = 'tan'; break;
      case 'log': result = math.log(current) / math.ln10; equationPrefix = 'log'; break;
      case 'ln': result = math.log(current); equationPrefix = 'ln'; break;
      case '√': 
        if (current < 0) { _currentInput = 'Error'; notifyListeners(); return; }
        result = math.sqrt(current); equationPrefix = '√'; break;
      case 'x²': result = math.pow(current, 2).toDouble(); equationPrefix = 'sqr'; break;
    }
    
    String eq = '$equationPrefix($current)';
    _currentInput = result.toString();
    _formatOutput();
    
    _history.insert(0, HistoryItem(eq, _currentInput));
    
    _shouldResetInput = true;
    notifyListeners();
  }

  void clear() {
    _currentInput = '0'; _previousInput = ''; _operator = ''; _shouldResetInput = false;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
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
      String eq = '$_currentInput%';
      _currentInput = (current / 100).toString();
      _formatOutput();
      _history.insert(0, HistoryItem(eq, _currentInput));
      notifyListeners();
    }
  }

  void calculate() {
    if (_operator.isEmpty || _previousInput.isEmpty) return;
    double? num1 = double.tryParse(_previousInput);
    double? num2 = double.tryParse(_currentInput);
    if (num1 == null || num2 == null) return;

    double result = 0;
    String eq = '$_previousInput $_operator $_currentInput';
    
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
    
    _history.insert(0, HistoryItem(eq, _currentInput));
    
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
