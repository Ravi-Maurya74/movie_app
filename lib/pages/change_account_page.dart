import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ChangeAccount extends StatefulWidget {
  static const routeName = '/change_account';
  const ChangeAccount({super.key});

  @override
  State<ChangeAccount> createState() => _ChangeAccountState();
}

class _ChangeAccountState extends State<ChangeAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool displayPreview = false;
  bool validProfilePicUrl = false;
  String newName = '';
  String profilePicUrl = '';

  Future<void> validateProfileUrl() async {
    debugPrint('checking');
    validProfilePicUrl =
        await NetworkHelper().validateImage(formatProfilePicUrl(profilePicUrl));
  }

  void showPreview() {
    setState(() {
      displayPreview = true;
    });
  }

  void hidePreview() {
    setState(() {
      displayPreview = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SingleTextField(
                        label: 'New Name',
                        child: TextFormField(
                          onChanged: (value) {
                            newName = value;
                            hidePreview();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Leave blank for same',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      SingleTextField(
                        label: 'New Profile Pic url',
                        child: TextFormField(
                          validator: (value) {
                            if (profilePicUrl.isEmpty) return null;
                            if (!isURL(value)) {
                              return 'Please enter a valid url.';
                            } else if (value!.length >= 250) {
                              return 'Length of url cannot be more than 250 characters';
                            } else if (!validProfilePicUrl) {
                              return 'Please enter a valid image url';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            profilePicUrl = value;
                            hidePreview();
                          },
                          minLines: 8,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintMaxLines: 20,
                            border: InputBorder.none,
                            hintText:
                                'Url of online image or google drive image. If uploading from google drive ensure access permission is provided. Leave blank for same',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (profilePicUrl.isEmpty) {
                                _formKey.currentState!.validate();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please fill profile pic url first.')));
                                return;
                              }
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text: 'Validating...',
                                barrierDismissible: false,
                              );
                              if (profilePicUrl.isNotEmpty) {
                                await validateProfileUrl();
                              }
                              if (!mounted) return;
                              Navigator.pop(context);
                              if (_formKey.currentState!.validate()) {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: 'Preview loaded.',
                                );
                                showPreview();
                              } else {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: 'Please provide valid data.',
                                );
                                hidePreview();
                              }
                            },
                            child: Text('Show Preview'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: displayPreview
                            ? CircleAvatar(
                                radius: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        formatProfilePicUrl(profilePicUrl),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            LoadingAnimationWidget.beat(
                                                color: Colors.amber, size: 20),
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.person);
                                    },
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (newName.isEmpty && profilePicUrl.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill atleast one of the field.')));
                              return;
                            }
                            if (profilePicUrl.isNotEmpty && !displayPreview) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please preview the image first.')));
                              return;
                            }
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              text: 'Continue to edit account?',
                              onConfirmBtnTap: () async {
                                Navigator.pop(context);
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.loading,
                                  text: 'Saving changes...',
                                  barrierDismissible: false,
                                );
                                await NetworkHelper().postData(
                                    url: 'editAccountInfo/',
                                    jsonMap: {
                                      'user_id': Provider.of<User>(context,
                                              listen: false)
                                          .id,
                                      'change_name': newName.isNotEmpty,
                                      'change_profile_pic':
                                          profilePicUrl.isNotEmpty,
                                      'name': newName,
                                      'profile_pic_url': profilePicUrl,
                                    });
                                Navigator.pop(context);
                                await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: 'Changes saved.',
                                  barrierDismissible: false,
                                );
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: const Text('Confirm'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleTextField extends StatelessWidget {
  const SingleTextField({
    required this.label,
    required this.child,
    Key? key,
  }) : super(key: key);
  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(width: 130, child: Text(label)),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: DecoratedContainer(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({required this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 42, 52, 1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: child,
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Edit Account Info',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // Text(
              //   '$count Reviews',
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

String formatProfilePicUrl(String url) {
  if (url.contains('drive.google.com')) {
    url = url.replaceFirst('file/d/', 'uc?export=view&id=');
    int end = url.indexOf('/view');
    // print(url.substring(0, end));
    return url.substring(0, end);
  }
  return url;
}
