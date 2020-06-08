import 'package:flutter/material.dart';
import 'package:my_design/widgets/dark_beveled_card.dart';
import 'package:my_design/widgets/verdict_stack.dart';
import 'package:my_design/data/centralized_data.dart';
import 'package:provider/provider.dart';

class VerdictScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) => SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: VerdictStack(),
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.top10Verdicts.length,
                    itemBuilder: (context, index) {
                      return DarkBeveledCard(
                        title: data.top10Verdicts.keys.elementAt(index),
                        subtitle: data.top10Verdicts.values.elementAt(index),
                        index: index,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
