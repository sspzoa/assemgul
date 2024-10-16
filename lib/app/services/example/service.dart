import 'dart:developer';

import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class ExampleService extends GetxController with StateMixin<Examples?> {
  final ExampleRepository repository;

  ExampleService({ExampleRepository? repository})
      : repository = repository ?? ExampleRepository();

  final Rx<Examples?> _pong = Rx(null);

  Examples? get pong => _pong.value;

  Future<Examples?> getExamples() async {
    try {
      Examples data = await repository.getExamples();
      _pong.value = data;
      return _pong.value;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
