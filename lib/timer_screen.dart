import 'package:flutter/material.dart';
import 'package:hengio/timer_provider.dart';
import 'package:hengio/timer_input.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final timerProvider = Provider.of<TimerProvider>(context);

  return Scaffold(
    appBar: AppBar(
      title: Center(
        child: Text(
          'HT team',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    extendBodyBehindAppBar: true,
    body: Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.6),
          radius: 1.0,
          colors: [Color(0xff1d2671), Color(0xffc33764)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Set Timer',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          TimerInput(),
          SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Text(
              timerProvider.timeLeft,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: timerProvider.isRunning
                    ? timerProvider.pauseTimer // Nếu đang chạy, bấm để dừng
                    : timerProvider.startTimer, // Nếu không, bấm để bắt đầu
                icon: Icon(
                  timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                label: Text(
                  timerProvider.isRunning ? 'Pause' : 'Start',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor:
                      timerProvider.canStart || timerProvider.isRunning
                          ? Colors.blueAccent
                          : Colors.grey, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed:
                    timerProvider.isRunning ? null : timerProvider.resetTimer,
                icon: Icon(Icons.restore, color: Colors.white),
                label: Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: timerProvider.isRunning
                      ? Colors.grey
                      : Colors.redAccent, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
