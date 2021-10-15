import 'package:freezed_annotation/freezed_annotation.dart';

part 'cflanguagedata.freezed.dart';

@freezed
class CFLanguageData with _$CFLanguageData {
  const factory CFLanguageData(String title, int value) = _CFLanguageData;
}
