import 'package:code_forces_tracker/core/verdict_colors.dart';
import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class VerdictFilterBar extends StatelessWidget {
  const VerdictFilterBar({super.key, required this.activeFilters, required this.onFiltersChanged});

  final ISet<CFSubmissionVerdict> activeFilters;
  final ValueChanged<ISet<CFSubmissionVerdict>> onFiltersChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: CFSubmissionVerdict.values.length,
        itemBuilder: (context, index) {
          final verdict = CFSubmissionVerdict.values[index];
          final isActive = activeFilters.contains(verdict);
          final color = verdictColor(verdict);
          return FilterChip(
            selected: isActive,
            label: Text(verdict.name),
            selectedColor: color.withValues(alpha: 0.25),
            checkmarkColor: color,
            side: BorderSide(color: isActive ? color : Colors.grey.shade300),
            onSelected: (_) {
              if (isActive) {
                onFiltersChanged(activeFilters.remove(verdict));
              } else {
                onFiltersChanged(activeFilters.add(verdict));
              }
            },
          );
        },
      ),
    );
  }
}
