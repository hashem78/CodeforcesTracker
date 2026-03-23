import 'package:flutter/widgets.dart';

// Material 3 breakpoints
const double _compact = 600; // phones
const double _medium = 840; // tablets
// >= 840 = expanded (desktop/linux)

// Max widths
const double formMaxWidth = 500;

extension AppSizingExt on BuildContext {
  double get _w => MediaQuery.sizeOf(this).width;

  // --- Horizontal padding ---
  double get paddingXS => switch (_w) {
    < _compact => 4,
    < _medium => 6,
    _ => 8,
  };
  double get paddingSM => switch (_w) {
    < _compact => 8,
    < _medium => 10,
    _ => 16,
  };
  double get paddingMD => switch (_w) {
    < _compact => 12,
    < _medium => 16,
    _ => 24,
  };
  double get paddingLG => switch (_w) {
    < _compact => 16,
    < _medium => 20,
    _ => 32,
  };
  double get paddingXL => switch (_w) {
    < _compact => 24,
    < _medium => 32,
    _ => 48,
  };

  // --- Vertical spacing ---
  double get spaceXXS => switch (_w) {
    < _compact => 2,
    < _medium => 2,
    _ => 4,
  };
  double get spaceXS => switch (_w) {
    < _compact => 4,
    < _medium => 6,
    _ => 8,
  };
  double get spaceSM => switch (_w) {
    < _compact => 8,
    < _medium => 10,
    _ => 12,
  };
  double get spaceMD => switch (_w) {
    < _compact => 16,
    < _medium => 18,
    _ => 24,
  };
  double get spaceLG => switch (_w) {
    < _compact => 24,
    < _medium => 28,
    _ => 32,
  };

  // --- Font sizes ---
  double get fontSM => switch (_w) {
    < _compact => 11,
    < _medium => 12,
    _ => 14,
  };
  double get fontMD => switch (_w) {
    < _compact => 12,
    < _medium => 13,
    _ => 16,
  };
  double get fontLG => switch (_w) {
    < _compact => 18,
    < _medium => 20,
    _ => 24,
  };
  double get fontXL => switch (_w) {
    < _compact => 48,
    < _medium => 56,
    _ => 72,
  };

  // --- Icon sizes ---
  double get iconSM => switch (_w) {
    < _compact => 18,
    < _medium => 20,
    _ => 24,
  };

  // --- Border radius ---
  double get radiusSM => switch (_w) {
    < _compact => 12,
    < _medium => 14,
    _ => 20,
  };

  // --- Chart-specific ---
  double get chartRadius => switch (_w) {
    < _compact => 80,
    < _medium => 100,
    _ => 140,
  };
  double get chartCenterSpace => switch (_w) {
    < _compact => 30,
    < _medium => 40,
    _ => 56,
  };
  double get legendDot => switch (_w) {
    < _compact => 10,
    < _medium => 12,
    _ => 16,
  };

  // --- Component heights ---
  double get filterBarHeight => switch (_w) {
    < _compact => 48,
    < _medium => 56,
    _ => 64,
  };

  // --- Visibility flags ---
  bool get isCompact => _w < _compact;
  bool get shortScreen => MediaQuery.sizeOf(this).height < 200;
}
