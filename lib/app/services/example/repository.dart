import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class ExampleRepository {
  final ApiProvider api;

  ExampleRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Examples> getExamples() async {
    String url = '/examples';

    CustomHttpResponse response = await api.get(url);

    Examples examples = Examples.fromJson(response.data);

    return examples;
  }
}