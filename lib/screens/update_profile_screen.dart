import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();

  Future<void> saveData(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  saveUserDetails() async {
    print(name.text);
    saveData("name", name.text);
    print(email.text);
    saveData("email", email.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Column(
        children: [
          customTextFieldWidget("Name", name),
          customTextFieldWidget("Email", email),
          ElevatedButton(
            onPressed: saveUserDetails,
            child: Text('Save Details'),
          ),
        ],
      ),
    );
  }
}

Widget customTextFieldWidget(String title, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
