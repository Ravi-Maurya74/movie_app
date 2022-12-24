import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:movie_app/widgets/custom_text_field.dart';
import 'package:movie_app/widgets/custom_button.dart';
import 'package:movie_app/widgets/custom_password_field.dart';
import 'package:movie_app/helpers/networking.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController profilePicController = TextEditingController();
  RegisterPage({super.key});

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
              Text('Create new account',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 10,
              ),
              const Text('Please fill in the form to continue'),
              SizedBox(
                height: dimensions.height * 0.1,
              ),
              CustomTextField(
                label: 'Full Name',
                iconData: Icons.person,
                textEditingController: nameController,
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
              ),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: 'URL of a web-image or a drive link',
                child: CustomTextField(
                  label: 'Profile pic url',
                  iconData: Icons.face_unlock_outlined,
                  textEditingController: profilePicController,
                  hint: 'Optional',
                ),
              ),
              const Spacer(),
              CustomButton(
                  dimensions: dimensions,
                  label: 'Sign Up',
                  action: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please provide complete info.')));
                      return;
                    }
                    Response response = await NetworkHelper()
                        .postData(url: 'createUser/', jsonMap: {
                      "email": emailController.text,
                      "password": passwordController.text,
                      "name": nameController.text,
                      "profile_pic_url": profilePicController.text
                    });
                    if (response.statusCode == 400) {
                      Map<String, dynamic> res = jsonDecode(response.body);
                      List<String> display = [];
                      res.forEach((key, value) {
                        display.add("$key: ${value[0]}");
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: display.map((e) => Text(e)).toList(),
                      )));
                      return;
                    }
                    var data = jsonDecode(response.body);
                    print(data);
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have an Account? ",
                    style: TextStyle(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text(
                      'Sign In',
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
