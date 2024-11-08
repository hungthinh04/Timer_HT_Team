import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hengio/timer_provider.dart';

class TimerInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeInput('Hours', timerProvider.hoursController, timerProvider.isRunning, _hoursInputFormatter),
        SizedBox(width: 16),
        buildTimeInput('Minutes', timerProvider.minutesController, timerProvider.isRunning, _minutesAndSecondsInputFormatter),
        SizedBox(width: 16),
        buildTimeInput('Seconds', timerProvider.secondsController, timerProvider.isRunning, _minutesAndSecondsInputFormatter),
      ],
    );
  }

  Widget buildTimeInput(String label, TextEditingController controller, bool isDisabled, List<TextInputFormatter> inputFormatters) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            enabled: !isDisabled,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Định dạng nhập cho Hours (tối đa 2 chữ số, không giới hạn giá trị)
  List<TextInputFormatter> get _hoursInputFormatter => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ];

  // Định dạng nhập cho Minutes và Seconds (hàng chục <= 5, hàng đơn vị không giới hạn)
  List<TextInputFormatter> get _minutesAndSecondsInputFormatter => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        _MinuteSecondInputFormatter(),
      ];
}

class _MinuteSecondInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }
    if (newText.length == 1) {
      final int? firstDigit = int.tryParse(newText[0]);
      if (firstDigit == null || firstDigit > 5) {
        return oldValue; 
      }
    }
    if (newText.length == 2) {
      final int? firstDigit = int.tryParse(newText[0]);
      final int? secondDigit = int.tryParse(newText[1]);
      if (firstDigit == null || firstDigit > 5 || secondDigit == null) {
        return oldValue;
      }
    }

    return newValue;
  }
}
