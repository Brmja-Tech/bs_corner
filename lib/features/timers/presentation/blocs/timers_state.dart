class TimersState {}

class TimersInitial extends TimersState {}

class TimersLoading extends TimersState {}

class TimerSuccess extends TimersState {
  final String message;
  TimerSuccess(this.message);
}

class TimerFailure extends TimersState {
  final String message;
  TimerFailure(this.message);
}
