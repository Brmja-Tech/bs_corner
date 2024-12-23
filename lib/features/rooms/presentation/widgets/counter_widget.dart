import 'dart:async';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final String initialTime;
  final Function(String) onElapsedTimeUpdate;
  final Function(String) onDatabaseUpdate;

  const CounterWidget({
    Key? key,
    required this.initialTime,
    required this.onElapsedTimeUpdate,
    required this.onDatabaseUpdate,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget>
    with AutomaticKeepAliveClientMixin {
  late Duration _duration;
  Timer? _timer;
  // int _secondsElapsed = 0; // Initialize seconds elapsed

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart the timer only if the initialTime changes
    if (oldWidget.initialTime != widget.initialTime) {
      _initializeTimer();
    }
  }

  void _initializeTimer() {
    _timer?.cancel(); // Cancel the existing timer
    _duration = _parseTime(widget.initialTime);
    // _secondsElapsed = 0; // Reset elapsed seconds
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Increment the duration and elapsed seconds
        _duration += const Duration(seconds: 1);
        // _secondsElapsed++;

        // Debugging logs
        // print('Elapsed seconds: $_secondsElapsed');
        // print('Current duration: ${_formatDuration(_duration)}');

        // Notify parent of elapsed time
        widget.onElapsedTimeUpdate(_formatDuration(_duration));

        // Trigger database update every 5 seconds
        if (_duration.inSeconds % 300 == 0) {
          // print('Database update triggered at ${_formatDuration(_duration)}');
          widget.onDatabaseUpdate(_formatDuration(_duration));
        }
      });
    });
  }

  Duration _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 3) {
      throw const FormatException('Invalid time format. Use HH:mm:ss');
    }
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text(
        _formatDuration(_duration),
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
