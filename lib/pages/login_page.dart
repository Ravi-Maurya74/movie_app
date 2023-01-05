import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/register_page.dart';
import 'package:movie_app/providers/loader.dart';
import 'package:movie_app/providers/user.dart';

import 'package:movie_app/widgets/custom_text_field.dart';
import 'package:movie_app/widgets/custom_button.dart';
import 'package:movie_app/widgets/custom_password_field.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();
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
                      final loader =
                          Provider.of<Loader>(context, listen: false);
                      loader.data.add(response);
                      loader.data.addAll(results);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context, HomePage.routeName);
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
