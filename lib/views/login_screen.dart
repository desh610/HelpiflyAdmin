import 'package:flutter/material.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/views/main_screen.dart';
import 'package:helpiflyadmin/widgets/custom_button.dart';
import 'package:helpiflyadmin/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 2,
        title: Text(
          "Helpifly Admin Portal",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: lightGrayColor),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: codeController,
                hintText: "Admin code",
                overlineText: '',
                backgroundColor: Colors.grey.shade800,
                obscureText: true,
              ),
              SizedBox(height: 15),
              CustomButton(
                onTap: () async {
                  if (codeController.text == "hadmin") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('logged-in', true);
                  }
                },
                buttonText: "Access",
                textColor: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
