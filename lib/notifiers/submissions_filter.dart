import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CFSubmissionsFilterNotifier
    extends StateNotifier<Set<CFSubmissionVerdict>> {
  CFSubmissionsFilterNotifier(this.ref) : super({});
  final ProviderReference ref;
  void add(CFSubmissionVerdict? verdict) {
    if (verdict != null) {
      state = {...state, verdict};
    }
  }

  void remove(CFSubmissionVerdict? verdict) {
    if (verdict != null) {
      final newState = {...state};
      newState.remove(verdict);
      state = newState;
    }
  }
}
