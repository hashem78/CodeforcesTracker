import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:flutter/material.dart';

Color verdictColor(CFSubmissionVerdict? verdict) => switch (verdict) {
  CFSubmissionVerdict.OK => Colors.green,
  CFSubmissionVerdict.WRONG_ANSWER => Colors.red,
  CFSubmissionVerdict.TIME_LIMIT_EXCEEDED => Colors.orange,
  CFSubmissionVerdict.MEMORY_LIMIT_EXCEEDED => Colors.amber.shade700,
  CFSubmissionVerdict.COMPILATION_ERROR => Colors.yellow.shade800,
  CFSubmissionVerdict.RUNTIME_ERROR => Colors.purple,
  CFSubmissionVerdict.PARTIAL => Colors.blue,
  CFSubmissionVerdict.IDLENESS_LIMIT_EXCEEDED => Colors.deepOrange,
  CFSubmissionVerdict.CHALLENGED => Colors.pink,
  CFSubmissionVerdict.FAILED => Colors.red.shade900,
  CFSubmissionVerdict.SECURITY_VIOLATED => Colors.brown,
  CFSubmissionVerdict.CRASHED => Colors.red.shade700,
  CFSubmissionVerdict.INPUT_PREPARATION_CRASHED => Colors.brown.shade700,
  CFSubmissionVerdict.SKIPPED => Colors.grey,
  CFSubmissionVerdict.TESTING => Colors.lightBlue,
  CFSubmissionVerdict.REJECTED => Colors.blueGrey,
  CFSubmissionVerdict.PRESENTATION_ERROR => Colors.teal,
  null => Colors.grey.shade400,
};

IconData verdictIcon(CFSubmissionVerdict? verdict) => switch (verdict) {
  CFSubmissionVerdict.OK => Icons.check_circle,
  CFSubmissionVerdict.WRONG_ANSWER => Icons.cancel,
  CFSubmissionVerdict.TIME_LIMIT_EXCEEDED => Icons.timer_off,
  CFSubmissionVerdict.MEMORY_LIMIT_EXCEEDED => Icons.memory,
  CFSubmissionVerdict.COMPILATION_ERROR => Icons.build_circle,
  CFSubmissionVerdict.RUNTIME_ERROR => Icons.bug_report,
  CFSubmissionVerdict.TESTING => Icons.hourglass_top,
  _ => Icons.help_outline,
};

const languageColorPalette = [
  Color(0xFF4285F4), // blue
  Color(0xFFEA4335), // red
  Color(0xFFFBBC05), // yellow
  Color(0xFF34A853), // green
  Color(0xFFFF6D01), // orange
  Color(0xFF46BDC6), // teal
  Color(0xFF7B1FA2), // purple
  Color(0xFFE91E63), // pink
  Color(0xFF00ACC1), // cyan
  Color(0xFF8D6E63), // brown
  Color(0xFF9E9E9E), // grey
  Color(0xFF5C6BC0), // indigo
];
