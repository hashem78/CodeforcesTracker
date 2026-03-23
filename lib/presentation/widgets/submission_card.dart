import 'package:code_forces_tracker/core/app_sizing.dart';
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
    final compact = context.isCompact;
    final submitted = DateTime.fromMillisecondsSinceEpoch(item.creationTimeSeconds * 1000);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.paddingMD, vertical: context.spaceXS),
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
                    padding: EdgeInsets.all(context.paddingMD),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!compact) ...[
                              Icon(verdictIcon(item.verdict), color: color, size: context.iconSM),
                              SizedBox(width: context.paddingSM),
                            ],
                            Expanded(
                              child: Text(
                                item.problem.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!compact && item.problem.rating != null) ...[
                              SizedBox(width: context.paddingSM),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.paddingSM,
                                  vertical: context.spaceXXS,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(context.radiusSM),
                                ),
                                child: Text(
                                  '${item.problem.rating}',
                                  style: TextStyle(fontSize: context.fontMD, fontWeight: FontWeight.bold, color: color),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: context.spaceXS),
                        Text(
                          [
                            item.programmingLanguage,
                            if (item.contestId != null) t.main.contestLabel(id: '${item.contestId}'),
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.spaceXXS),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                [
                                  t.main.runtime(ms: '${item.timeConsumedMillis}'),
                                  if (!compact) t.main.memory(kb: '${(item.memoryConsumedBytes / 1024).round()}'),
                                ].join(' · '),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                              ),
                            ),
                            if (!compact) ...[
                              SizedBox(width: context.paddingSM),
                              Flexible(
                                child: Text(
                                  timeago.format(submitted),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                                ),
                              ),
                            ],
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
