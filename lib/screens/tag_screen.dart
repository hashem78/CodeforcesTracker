import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../widgets/important_data.dart';
import '../constants.dart';
import 'package:my_design/widgets/tag_stack.dart';

class ToggleableBool {
  bool flag = false;
  void toggle() {
    flag = !flag;
  }
}

class TagScreen extends StatelessWidget {
  final ToggleableBool flag = ToggleableBool();
  @override
  Widget build(BuildContext context) {
    if (!flag.flag) {
      Provider.of<ImportantData>(context).updateTagsFromCF();
      Provider.of<ImportantData>(context).updateTop10();
      flag.toggle();
    }
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Tags",
            style: TextStyle(),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {}),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 30,
                ),
                onPressed: () {})
          ],
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: TagStack(),
              height: 400,
              color: Colors.black,
            ),
            Consumer<ImportantData>(
              builder: (context, data, child) {
                return Expanded(
                  child: Scrollbar(
                                      child: ListView.builder(
                      cacheExtent: 70000,
                        shrinkWrap: true,
                        itemCount: data.top10.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            shape: BeveledRectangleBorder(),
                            color: Colors.black,
                            child: ListTile(
                              leading: Text(
                                index.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              title: Text(
                                data.top10.keys.elementAt(index),
                              ),
                              subtitle: Text(
                                  data.top10.values.elementAt(index).join(", ")),
                            ),
                          );
                        }),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
