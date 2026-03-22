import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class VerdictFilterBar extends StatelessWidget {
  const VerdictFilterBar({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
  });

  final ISet<CFSubmissionVerdict> activeFilters;
  final ValueChanged<ISet<CFSubmissionVerdict>> onFiltersChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 7,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: CFSubmissionVerdict.values.map<Widget>((verdict) {
          final isActive = activeFilters.contains(verdict);
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: OutlinedButton(
              onPressed: () {
                if (isActive) {
                  onFiltersChanged(activeFilters.remove(verdict));
                } else {
                  onFiltersChanged(activeFilters.add(verdict));
                }
              },
              child: Text(
                verdict.name,
                style: TextStyle(
                  color: isActive ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
