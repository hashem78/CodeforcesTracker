import 'package:flutter/material.dart';
import 'package:my_design/constants.dart';
import 'package:my_design/data/centralized_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

SnackBar workingSnackBar = SnackBar(
  backgroundColor: Colors.transparent,
  content: ListTile(
    leading: CircularProgressIndicator(),
    title: Text(
      kWORKING_SNAKCBAR_TEXT,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
      ),
    ),
  ),
  duration: Duration(
    seconds: kWORKING_SNACKBAR_DURATION_SECONDS,
  ),
);

SnackBar errorSnackBar = SnackBar(
  backgroundColor: Colors.transparent,
  content: ListTile(
    leading: Icon(
      Icons.error,
      color: Colors.red,
    ),
    title: Text(
      kERROR_HANDEL_DNE_TEXT,
      style: TextStyle(
        color: Colors.red,
      ),
    ),
  ),
  duration: Duration(
    seconds: kERROR_SNACK_BACK_DURATION_SECONDS,
  ),
);

class MainScreen extends StatelessWidget {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  kHANDEL_MAIN_SCREEN_TITLE,
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
                      //autofocus: true,
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
                  builder: (innerContext) => ElevatedButton(
                    child: Text(kHANDEL_TRACK_BUTTON_TEXT),
                    onPressed: () async {
                      ScaffoldMessenger.maybeOf(innerContext)?.showSnackBar(workingSnackBar);
                      String url =
                          "https://codeforces.com/api/user.status?handle=${myController.text}&count=1";
                      http.Response valid = await http.get(Uri.parse(url));
                      if ( valid.statusCode != 200) {
                      ScaffoldMessenger.maybeOf(innerContext)?.showSnackBar(errorSnackBar);
                      } else {
                        Provider.of<Data>(context, listen: false)
                            .updateHandle(myController.text);
                        await Provider.of<Data>(context, listen: false)
                            .pullDataFromCF();

                        Navigator.pushNamed(context, "/tabs");
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
