import 'package:code_forces_tracker/hooks/use_paging_controller.dart';
import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/providers/repository.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:code_forces_tracker/presentation/widgets/verdict_filter_bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class LatestSubmissionsTab extends HookConsumerWidget {
  const LatestSubmissionsTab({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(cfRepositoryProvider(handle));
    final t = ref.watch(localeProvider);
    final activeFilters = useState(const ISet<CFSubmissionVerdict>.empty());

    final paging = usePagingController<CFSubmission>(
      keys: [handle, activeFilters.value],
      fetchPage: (from, count) async {
        final (items, getUserState) = await repository.getUserStatus(
          filters: activeFilters.value.unlockView,
          from: from,
          count: count,
        );
        return switch (getUserState) {
          GetUserState.normal => (items, PageStatus.done),
          _ => (items, PageStatus.hasMore),
        };
      },
    );

    return RefreshIndicator(
      onRefresh: () async => paging.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: VerdictFilterBar(
              activeFilters: activeFilters.value,
              onFiltersChanged: (filters) => activeFilters.value = filters,
            ),
          ),
          PagedSliverList<int, CFSubmission>(
            state: paging.state,
            fetchNextPage: paging.controller.fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate<CFSubmission>(
              itemBuilder: (context, item, index) {
                return ListTile(
                  title: Text(item.problem.name),
                  onTap: () async {
                    if (item.url != null) {
                      final uri = Uri.parse(item.url!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    }
                  },
                  subtitle: Text(
                    item.verdict != null
                        ? t.main.verdict(verdict: item.verdict!.name)
                        : t.main.verdictUnavailable,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
