import 'package:fl_chart/fl_chart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cflanguages.freezed.dart';

@freezed
abstract class CFLanguages with _$CFLanguages {
  const factory CFLanguages.loading() = _CFLanguagesLoading;
  const factory CFLanguages.data({required List<PieChartSectionData> data}) =
      _CFLanguagesData;
  const factory CFLanguages.error([String? error]) = _CFLanguagesError;
}
