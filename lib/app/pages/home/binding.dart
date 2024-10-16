import 'package:get/get.dart';

import '../../services/example/service.dart';
import 'controller.dart';

class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => ExampleService());
  }
}
