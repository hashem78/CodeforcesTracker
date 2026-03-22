import 'package:code_forces_tracker/core/verdict_colors.dart';
import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class SubmissionCard extends ConsumerWidget {
  const SubmissionCard({super.key, required this.item});
  final CFSubmission item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localeProvider);
    final color = verdictColor(item.verdict);
    final submitted = DateTime.fromMillisecondsSinceEpoch(
      item.creationTimeSeconds * 1000,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            if (item.url != null) {
              final uri = Uri.parse(item.url!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 4, color: color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              verdictIcon(item.verdict),
                              color: color,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.problem.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.problem.rating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${item.problem.rating}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [
                            item.programmingLanguage,
                            if (item.contestId != null)
                              t.main.contestLabel(id: '${item.contestId}'),
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              [
                                t.main.runtime(ms: '${item.timeConsumedMillis}'),
                                t.main.memory(
                                  kb: '${(item.memoryConsumedBytes / 1024).round()}',
                                ),
                              ].join(' · '),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              timeago.format(submitted),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
