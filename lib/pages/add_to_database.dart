import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:validators/validators.dart';

class AddToDatabase extends StatefulWidget {
  static const routeName = 'add_to_database/';
  const AddToDatabase({super.key});

  @override
  State<AddToDatabase> createState() => _AddToDatabaseState();
}

class _AddToDatabaseState extends State<AddToDatabase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imageUrl = '';
  String name = '';
  bool hasData = false;
  bool validImageUrl = false;

  Future<void> validateImageUrl() async {
    debugPrint('checking');
    validImageUrl = await NetworkHelper().validateImage(imageUrl);
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 150, child: Text('Name: ')),
                          Expanded(
                            child: Container(
                              // margin: const EdgeInsets.only(left: 20),
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(37, 42, 52, 1),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  name = value;
                                  setState(() {
                                    hasData = false;
                                  });
                                },
                                validator: (value) => value!.isEmpty
                                    ? 'This field is required.'
                                    : null,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              width: 150, child: Text('Display Pic Url: ')),
                          Expanded(
                            child: Container(
                              // margin: const EdgeInsets.only(left: 20),
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(37, 42, 52, 1),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  imageUrl = value;
                                  setState(() {
                                    hasData = false;
                                  });
                                },
                                validator: (value) {
                                  if (!isURL(value)) {
                                    return 'Please enter a valid url.';
                                  } else if (value!.length >= 250) {
                                    return 'Length of url cannot be more than 250 characters';
                                  } else if (!validImageUrl) {
                                    return 'Please enter a valid image url';
                                  }
                                  return null;
                                },
                                minLines: 7,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () async {
                                await validateImageUrl();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    hasData = true;
                                  });
                                } else {
                                  setState(() {
                                    hasData = false;
                                  });
                                }
                              },
                              child: Text(
                                'Preview',
                                style: Theme.of(context).textTheme.titleMedium,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      hasData
                          ? Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.black12,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                LoadingAnimationWidget.beat(
                                                    color: Colors.amber,
                                                    size: 20),
                                        errorWidget: (context, url, error) {
                                          return const Icon(Icons.error);
                                        },
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        onConfirmBtnTap: () async {
                                          Navigator.pop(context);
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.loading,
                                            barrierDismissible: false,
                                            text: 'Saving...',
                                          );
                                          await NetworkHelper().postData(
                                              url: 'addNewCast/',
                                              jsonMap: {
                                                "name": name,
                                                "profile_pic_url": imageUrl,
                                              });
                                          Navigator.pop(context);
                                          await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              barrierDismissible: false,
                                              text:
                                                  'You can now add this cast to any movie.',
                                              autoCloseDuration:
                                                  const Duration(minutes: 5));
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Add',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ))
                              ],
                            )
                          : const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black12,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
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
                'Add to Database',
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
