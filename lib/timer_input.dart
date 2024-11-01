import 'package:flutter/material.dart';
import 'package:hengio/timer_provider.dart';
import 'package:provider/provider.dart';

class TimerInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeInput('Giờ', timerProvider.hoursController),
        SizedBox(width: 8),
        buildTimeInput('Phút', timerProvider.minutesController),
        SizedBox(width: 8),
        buildTimeInput('Giây', timerProvider.secondsController),
      ],
    );
  }

  Widget buildTimeInput(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(label),
        SizedBox(height: 8),
        Container(
          width: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
