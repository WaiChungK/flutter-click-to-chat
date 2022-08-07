import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globals.appBarTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(globals.appBarTitle),
      ),
      body: const PhoneInput(),
    );
  }
}

class PhoneInput extends StatefulWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  // Overkill but just for learning purpose
  final myController = TextEditingController();

  String? phoneInput;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_savePhoneInput);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _savePhoneInput listener.
    myController.dispose();
    super.dispose();
  }

  void _savePhoneInput() {
    phoneInput = myController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: myController,
            maxLength: 15,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.phone),
              hintMaxLines: 15,
              hintText: globals.hintText,
            ),
            validator: (String? input) {
              if (input == null || input.isEmpty) {
                return globals.requiredError;
              }

              // if contains too little digits
              if (input.length <= 7) {
                return globals.minimumLengthError;
              }

              // if contains characters other than digits
              if (input.contains(RegExp(r'[^\d]'))) {
                return globals.invalidCharacterError;
              }

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // https://wa.me/1XXXXXXXXXX
                  Uri url = Uri.parse('https://wa.me/${phoneInput}');

                  _launchUrl(url);
                }
              },
              child: const Icon(Icons.arrow_circle_right_sharp),
            ),
          )
        ],
      ),
    );
  }
}
