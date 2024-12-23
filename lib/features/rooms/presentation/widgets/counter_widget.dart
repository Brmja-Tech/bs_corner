import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/label.dart';

class CounterWidget extends StatefulWidget {
  final String initialTime;
  final bool isPaused;
  final Function(String) onElapsedTimeUpdate;
  final Function(String) onDatabaseUpdate;

  const CounterWidget({
    super.key,
    required this.initialTime,
    required this.onElapsedTimeUpdate,
    required this.onDatabaseUpdate,
    required this.isPaused,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget>
    with AutomaticKeepAliveClientMixin {
  late Duration _duration;
  Timer? _timer;

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
      // _initializeTimer();
    }
  }

  void _initializeTimer() {
    _timer?.cancel(); // Cancel the existing timer
    _duration = _parseTime(widget.initialTime);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // logger('Periodic timer Paused: ${widget.isPaused}');
      if (widget.isPaused) return;
      setState(() {
        _duration += const Duration(seconds: 1);
        widget.onElapsedTimeUpdate(_formatDuration(_duration));
        if (_duration.inSeconds % 300 == 0) {
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
      child: Label(
        text:_formatDuration(_duration),
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
