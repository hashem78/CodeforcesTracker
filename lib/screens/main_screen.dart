import 'package:flutter/material.dart';
import 'package:my_design/widgets/important_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatelessWidget {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<bool> checkValidHandel(String handel) async {
    String url = "https://codeforces.com/api/user.status?handle=${handel}";
    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter your handel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Material(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      controller: myController,
                    ),
                  ),
                ),
                Builder(
                  builder: (innerContext) => RaisedButton(
                    child: Text("Track"),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      bool valid = await checkValidHandel(myController.text);
                      if (!valid) {
                        Scaffold.of(innerContext).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.transparent,
                            content: ListTile(
                              leading: Icon(
                                Icons.error,
                              ),
                              title: Text(
                                "Error! handel does not exist",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        Provider.of<StackData>(context, listen: false)
                            .updateHandle(myController.text);
                        Provider.of<StackData>(context, listen: false)
                            .updateTagsFromCF();
                        Provider.of<StackData>(context, listen: false)
                            .updateTop10();
                        Navigator.pushNamed(context, "/tagScreen");
                      }
                    },
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
