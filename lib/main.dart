```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ø©',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _isNewOperation = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewOperation) {
        _display = digit;
        _isNewOperation = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_firstOperand == null) {
        _firstOperand = double.tryParse(_display);
      } else if (!_isNewOperation) {
        _firstOperand = _calculateResult();
      }
      _operator = operator;
      _expression = '${_formatNumber(_firstOperand!)} $operator';
      _isNewOperation = true;
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_firstOperand != null && _operator != null) {
        final result = _calculateResult();
        _expression = '${_formatNumber(_firstOperand!)} $_operator ${_formatNumber(double.parse(_display))} =';
        _display = _formatNumber(result);
        _firstOperand = null;
        _operator = null;
        _isNewOperation = true;
      }
    });
  }

  double _calculateResult() {
    final secondOperand = double.tryParse(_display) ?? 0;
    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand! * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0 ? _firstOperand! / secondOperand : double.nan;
        break;
      default:
        result = secondOperand;
    }
    return result;
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewOperation = true;
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final value = double.tryParse(_display) ?? 0;
      _display = _formatNumber(value / 100);
      _isNewOperation = true;
    });
  }

  void _onToggleSignPressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
        _isNewOperation = false;
      }
    });
  }

  String _formatNumber(double number) {
    if (number.isNaN) {
      return 'Ø®Ø·Ø£';
    }
    if (number == number.floorToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Widget _buildButton(String text, {Color? backgroundColor, Color? textColor, double flex = 1}) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: () {
              switch (text) {
                case 'C':
                  _onClearPressed();
                  break;
                case 'Â±':
                  _onToggleSignPressed();
                  break;
                case '%':
                  _onPercentagePressed();
                  break;
                case 'Ã·':
                case 'Ã':
                case '-':
                case '+':
                  _onOperatorPressed(text);
                  break;
                case '=':
                  _onEqualsPressed();
                  break;
                case '.':
                  _onDecimalPressed();
                  break;
                default:
                  _onDigitPressed(text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: textColor ?? Theme.of(context).colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: text == 'C' ? 20 : 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ø©'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _display,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
            // Button grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('C', backgroundColor: colorScheme.errorContainer, textColor: colorScheme.onErrorContainer),
                      _buildButton('Â±'),
                      _buildButton('%'),
                      _buildButton('Ã·', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('Ã', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0', flex: 2),
                      _buildButton('.'),
                      _buildButton('=', backgroundColor: colorScheme.primary, textColor: colorScheme.onPrimary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```