import 'package:flutter/material.dart';
import 'package:hengio/timer_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TimerInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeInput('Hours', timerProvider.hoursController, timerProvider.isRunning),
        SizedBox(width: 16),
        buildTimeInput('Minutes', timerProvider.minutesController, timerProvider.isRunning),
        SizedBox(width: 16),
        buildTimeInput('Seconds', timerProvider.secondsController, timerProvider.isRunning),
      ],
    );
  }

  Widget buildTimeInput(String label, TextEditingController controller, bool isDisabled) {
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
            ],
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
}
