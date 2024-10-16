import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// g.dart 파일 생성 : dart run build_runner build

@JsonSerializable()
class Examples {
  List<String> examples;

  Examples({
    required this.examples,
  });

  factory Examples.fromJson(Map<String, dynamic> json) =>
      _$ExamplesFromJson(json);

  Map<String, dynamic> toJson() => _$ExamplesToJson(this);
}