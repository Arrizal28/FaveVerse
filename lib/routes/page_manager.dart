import 'dart:async';

import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  late Completer<Map<String, dynamic>> _completer;

  Future<Map<String, dynamic>> waitForResult() async {
    _completer = Completer<Map<String, dynamic>>();
    return _completer.future;
  }

  void returnData(Map<String, dynamic> value) {
    _completer.complete(value);
  }
}