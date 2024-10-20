import 'dart:async';
import 'dart:collection';

import 'package:async_task_queue/src/async_task.dart';
import 'package:async_task_queue/src/processing_state.dart';

export 'src/async_task.dart';

abstract mixin class AsyncTaskQueue {
  final _taskQueue = ListQueue<AsyncTask>(0);
  var _processingState = ProcessingState.idle;

  void addTask(AsyncTask newTask) {
    _taskQueue.add(newTask);
    _triggerHeadExecution();
  }

  Future<void> _triggerHeadExecution() async {
    if (_processingState == ProcessingState.processing) {
      // already precessing the queue, any newly added tasks will be executed.
      return;
    }

    // flag processing
    _processingState = ProcessingState.processing;

    while (_taskQueue.isNotEmpty) {
      final head = _taskQueue.removeFirst();
      try {
        await head.task.call();
      } catch (e, st) {
        head.errorCallback?.call(e, st);
      }
    }

    // flag idle
    _processingState = ProcessingState.idle;
  }
}
