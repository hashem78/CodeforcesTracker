import 'package:code_forces_tracker/models/cfsubmissions.dart';
import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmissionsNotifier extends StateNotifier<CFSubmissions> {
  SubmissionsNotifier(String handle)
      : _repository = CFRepository(handle: handle),
        super(const CFSubmissions.initial());
  final CFRepository _repository;
  final Set<CFSubmissionVerdict> filters = {};
  void removeFilter(CFSubmissionVerdict filter) {
    filters.remove(filter);
  }

  void addFilter(CFSubmissionVerdict filter) {
    filters.add(filter);
  }

  Future<void> getSubmissions({
    int from = 1,
    int count = 10,
  }) async {
    try {
      final submissions = await _repository.getUserStatus(
        filters: filters,
        from: from,
        count: count,
      );
      
      state = CFSubmissions.data(
        submissions: submissions.item1,
        nextFrom: from + count,
        getUserState: submissions.item2,
      );
    } catch (e) {
      //state = CFSubmissions.error(e.toString());
    }
  }
}
