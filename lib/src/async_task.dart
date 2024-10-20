import 'dart:async';

class AsyncTask {
  final FutureOr<dynamic> Function() task;
  final void Function(dynamic error, StackTrace stacktrace)? errorCallback;

  AsyncTask({
    required this.task,
    this.errorCallback,
  });
}
