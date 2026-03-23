import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Result of a single page fetch.
enum PageStatus {
  /// More pages may be available.
  hasMore,

  /// No more data exists beyond this page.
  done,
}

typedef PageResult<T> = (List<T> items, PageStatus status);
typedef FetchPage<T> = Future<PageResult<T>> Function(int from, int count);

class PagingResult<T> {
  final PagingController<int, T> controller;
  final PagingState<int, T> state;

  /// Resets pagination and re-fetches from the beginning.
  void refresh() {
    _resetNextFrom();
    controller.refresh();
  }

  final VoidCallback _resetNextFrom;

  PagingResult._({required this.controller, required this.state, required VoidCallback resetNextFrom})
    : _resetNextFrom = resetNextFrom;
}

/// A reusable hook that manages a [PagingController] with offset-based
/// pagination, automatic disposal, retry logic, and a reactive [PagingState].
///
/// [fetchPage] receives `(from, count)` and returns a [PageResult] with items
/// and a [PageStatus] indicating whether more pages exist.
///
/// When a page returns no items but [PageStatus.hasMore], the hook
/// automatically advances the offset and retries, up to [maxRetries] times
/// with [retryDelay] between attempts.
///
/// [keys] controls when the controller is recreated.
PagingResult<T> usePagingController<T>({
  required FetchPage<T> fetchPage,
  int pageSize = 10,
  int maxRetries = 5,
  Duration retryDelay = const Duration(milliseconds: 500),
  List<Object?> keys = const [],
}) {
  final nextFrom = useRef<int?>(1);

  final controller = useMemoized(
    () => PagingController<int, T>(
      getNextPageKey: (state) => nextFrom.value,
      fetchPage: (pageKey) async {
        var currentFrom = pageKey;
        final accumulated = <T>[];

        for (var attempt = 0; attempt <= maxRetries; attempt++) {
          if (attempt > 0) {
            await Future.delayed(retryDelay);
          }

          final (items, status) = await fetchPage(currentFrom, pageSize);
          accumulated.addAll(items);
          currentFrom += pageSize;

          if (status == PageStatus.done) {
            nextFrom.value = null;
            return accumulated;
          }

          if (accumulated.isNotEmpty) {
            nextFrom.value = currentFrom;
            return accumulated;
          }
        }

        nextFrom.value = currentFrom;
        return accumulated;
      },
    ),
    keys,
  );

  useEffect(() => controller.dispose, [controller]);

  final state = useValueListenable(controller);

  return PagingResult._(controller: controller, state: state, resetNextFrom: () => nextFrom.value = 1);
}
