import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/register_page.dart';

import 'package:movie_app/widgets/custom_text_field.dart';
import 'package:movie_app/widgets/custom_button.dart';
import 'package:movie_app/widgets/custom_password_field.dart';

import 'package:http/http.dart';
 
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: dimensions.height,
          width: dimensions.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: dimensions.height * 0.1,
              ),
              Text('Welcome !', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 10,
              ),
              const Text('Please sign in to your account'),
              SizedBox(
                height: dimensions.height * 0.1,
              ),
              CustomTextField(
                label: 'Email',
                iconData: Icons.email,
                textEditingController: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomPasswordField(
                label: 'Password',
                iconData: Icons.lock,
                textEditingController: passwordController,
              ),
              const Spacer(),
              CustomButton(
                  dimensions: dimensions,
                  label: 'Sign In',
                  action: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please provide complete info.')));
                      return;
                    }
                    Response response = await NetworkHelper().postData(
                        url: 'login/',
                        jsonMap: {
                          "email": emailController.text,
                          "password": passwordController.text
                        });
                    if (response.statusCode == 200) {
                      var jsonResponse = jsonDecode(response.body);
                      if (jsonResponse['status'] == 400) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(jsonResponse['prompt'])));
                        return;
                      }
                      var data = jsonResponse['data'];
                      print(data);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't have an Account? ",
                    style: TextStyle(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RegisterPage.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: dimensions.height * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
