import 'package:cryptocurrency_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();

  bool isDarkModeEnabled = AppTheme.isDarkModeEnabled;

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
      backgroundColor: isDarkModeEnabled ? Colors.black : Colors.white,
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

  Widget customTextFieldWidget(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : null),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkModeEnabled ? Colors.white : Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkModeEnabled ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }
}
