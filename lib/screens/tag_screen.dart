import 'package:flutter/material.dart';
import 'package:my_design/widgets/dark_beveled_card.dart';
import 'package:my_design/widgets/tag_stack.dart';
import 'package:my_design/data/centralized_data.dart';
import 'package:provider/provider.dart';

class TagScreen extends StatelessWidget {
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
                  child: TagStack(),
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.top10Tags.length,
                    itemBuilder: (context, index) {
                      return DarkBeveledCard(
                        title: data.top10Tags.keys.elementAt(index),
                        subtitle:
                            data.top10Tags.values.elementAt(index).join(", "),
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
