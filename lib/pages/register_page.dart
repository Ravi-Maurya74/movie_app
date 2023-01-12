import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/providers/loader.dart';
import 'package:movie_app/providers/user.dart';

import 'package:movie_app/widgets/custom_text_field.dart';
import 'package:movie_app/widgets/custom_button.dart';
import 'package:movie_app/widgets/custom_password_field.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController profilePicController = TextEditingController();
  final box = GetStorage();
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text('Create new account',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 10,
              ),
              const Text('Please fill in the form to continue'),
              const SizedBox(height: 70),
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
              CustomTextField(
                label: 'Profile pic url',
                iconData: Icons.face_unlock_outlined,
                textEditingController: profilePicController,
                hint: 'Optional, can add later too..',
              ),
              const SizedBox(
                height: 70,
              ),
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
                    box.write('user_id', data['id'] as int);
                    // print(data);
                    Provider.of<User>(context, listen: false).update(
                        id: data['id'],
                        email: data['email'],
                        password: data['password'],
                        name: data['name'],
                        profilePicUrl: data['profile_pic_url']);
                    final results = await Future.wait([
                      NetworkHelper().getData(url: 'genre/'),
                      NetworkHelper().getData(url: 'topRatedMovies/'),
                      NetworkHelper().getData(url: 'mostUpvotedMovies/'),
                    ]);
                    final loader = Provider.of<Loader>(context, listen: false);
                    loader.data.add(response);
                    loader.data.addAll(results);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, HomePage.routeName);
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
                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName);
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
            ],
          ),
        ),
      ),
    );
  }
}
