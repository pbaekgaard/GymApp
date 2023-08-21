// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/constants/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/gym.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String? themeMode;
  bool isLoading = false;
  late List<Gym> gymList;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _gymNameController = TextEditingController();
  late SharedPreferences prefs;
  late Color chosenColor;

  @override
  void initState() {
    super.initState();
    fetchGyms();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future fetchGyms() async {
    setState(() {
      isLoading = true;
    });
    gymList = await AppDatabase.instance.getGyms();
    prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getString("privatekey");
    print(themeMode);
    setState(
      () => isLoading = false,
    );
  }

  Future<void> addGymDialog(BuildContext context) async {
    chosenColor = Theme.of(context).colorScheme.secondary;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                actions: <Widget>[
                  TextButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Gym newGym = Gym(
                            gymName: _gymNameController.text,
                            color: chosenColor.value);
                        await AppDatabase.instance.addGym(newGym);
                        gymList.add(newGym);
                        _gymNameController.clear();
                        setState(() => (gymList = gymList));
                        Navigator.of(context).pop(context);
                      }
                    },
                  )
                ],
                scrollable: true,
                content: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _gymNameController,
                          autofocus: true,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                                return "Gym name must contain at least one alphabetical character.";
                              } else if (gymList
                                  .map((e) => e.gymName)
                                  .contains(value)) {
                                return "You already have a gym with this name!";
                              } else {
                                return null;
                              }
                            } else {
                              return "Invalid Input";
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "e.g: FW Eternitten",
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                              labelText: "Gym name:"),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () async {
                                  await showColorPicker();
                                  setState(() => ());
                                },
                                child: const Text("Choose color")),
                            Icon(
                              Icons.stop,
                              color: chosenColor,
                            )
                          ],
                        )
                      ],
                    )));
          });
        });
  }

  Future<void> showColorPicker() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: BlockPicker(
                pickerColor: chosenColor,
                onColorChanged: (value) {
                  setState(() => chosenColor = value);
                  Navigator.of(context).pop();
                },
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<ThemeService>(builder: (context, ThemeService theme, _) {
            return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                    iconTheme: IconThemeData(
                        color: Theme.of(context).colorScheme.secondary),
                    elevation: 0,
                    // TRY THIS: Try changing the color here to a specific color (to
                    // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
                    // change color while the other colors stay the same.
                    backgroundColor: Theme.of(context).colorScheme.background,
                    // Here we take the value from the MyHomePage object that was created by
                    // the App.build method, and use it to set our appbar title.
                    centerTitle: true,
                    title: Text("Preferences",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
                body: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                  top: 20,
                                ),
                                child: Text("Theme Mode",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground)),
                              ),
                              Consumer<ThemeService>(
                                  builder: (context, ThemeService theme, _) {
                                return RadioListTile(
                                    title: const Row(children: [
                                      Icon(Symbols.night_sight_auto),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text("Follow system"),
                                      )
                                    ]),
                                    contentPadding: const EdgeInsets.all(0),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: 'system',
                                    groupValue: themeMode,
                                    onChanged: (String? value) async {
                                      theme.setTheme(value!);
                                      setState(() {
                                        themeMode = value;
                                      });
                                    });
                              }),
                              Consumer<ThemeService>(
                                  builder: (context, ThemeService theme, _) {
                                return RadioListTile(
                                    title: const Row(children: [
                                      Icon(Symbols.dark_mode),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text("Dark mode"),
                                      )
                                    ]),
                                    contentPadding: const EdgeInsets.all(0),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: 'dark',
                                    groupValue: themeMode,
                                    onChanged: (String? value) async {
                                      theme.setTheme(value!);
                                      setState(() {
                                        themeMode = value;
                                      });
                                    });
                              }),
                              Consumer<ThemeService>(
                                  builder: (context, ThemeService theme, _) {
                                return RadioListTile(
                                    title: const Row(children: [
                                      Icon(Symbols.light_mode),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text("Light mode"),
                                      )
                                    ]),
                                    contentPadding: const EdgeInsets.all(0),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: 'light',
                                    groupValue: themeMode,
                                    onChanged: (String? value) async {
                                      theme.setTheme(value!);
                                      setState(() {
                                        themeMode = value;
                                      });
                                    });
                              }),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                  top: 20,
                                ),
                                child: Text("Gyms",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground)),
                              ),
                              isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Column(
                                      children: [
                                        if (gymList.isNotEmpty)
                                          for (Gym gym in gymList)
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(gym.gymName),
                                                    Row(
                                                      children: [
                                                        const Text("Color:"),
                                                        Icon(
                                                          Icons.stop,
                                                          color:
                                                              Color(gym.color),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )),
                                        // Container(
                                        //     padding: EdgeInsets.all(15),
                                        //     width: MediaQuery.of(context).size.width,
                                        //     decoration: BoxDecoration(
                                        //         color: Theme.of(context)
                                        //             .colorScheme
                                        //             .secondaryContainer,
                                        //         borderRadius: BorderRadius.circular(15)),
                                        //     child: Icon(
                                        //       Icons.add,
                                        //       color:
                                        //           Theme.of(context).colorScheme.secondary,
                                        //     )),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextButton(
                                            onPressed: () async {
                                              await addGymDialog(context);
                                              setState(() {
                                                gymList = gymList;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondaryContainer,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                            ],
                          ),
                        ],
                      )),
                ));
          });
  }
}
