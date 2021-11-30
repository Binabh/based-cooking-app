import 'package:based_cooking/base/database.dart';
import 'package:based_cooking/constants/colors.dart';
import 'package:based_cooking/constants/theme.dart';
import 'package:based_cooking/repositories/get_files.dart';
import 'package:based_cooking/screens/recipe.dart';
import 'package:based_cooking/utils/debouncer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getFilesRepository.getAllRecipes();
    super.initState();
  }

  final _deBouncer = DeBouncer(delay: const Duration(milliseconds: 500));

  String title = "";
  String tag = "";
  bool searchMode = false;
  _info() {
    showDialog(
        context: context,
        builder: (context) {
          TextStyle _headingStyle = Theme.of(context).textTheme.headline1!;
          TextStyle _bodyStyle = Theme.of(context).textTheme.bodyText1!;
          return SimpleDialog(
            backgroundColor: BasedColors.lightBlack,
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: BasedColors.tomato, width: 1.5)),
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: "About Based Cooking\n", style: _headingStyle),
                TextSpan(
                    text: "This app uses data from open source project ",
                    style: _bodyStyle),
                TextSpan(
                    text: "based.cooking.",
                    style: _bodyStyle.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://based.cooking");
                      }),
                TextSpan(
                    text: "You can find the source code ", style: _bodyStyle),
                TextSpan(
                    text: "here. ",
                    style: _bodyStyle.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://github.com/lukesmithxyz/based.cooking");
                      }),
                TextSpan(
                    text:
                        "Please visit the site for web version, philosophy behind this project and also if you want to donate or contribute towards the project. \n",
                    style: _bodyStyle),
                TextSpan(text: "How to contribute?\n", style: _headingStyle),
                TextSpan(text: "Please read", style: _bodyStyle),
                TextSpan(
                    text: " this ",
                    style: _bodyStyle.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(
                            "https://github.com/LukeSmithxyz/based.cooking/blob/master/README.md");
                      }),
                TextSpan(
                    text:
                        "short readme if you want to contribute recipes to the project. Currently the only way is submitting pull request to the git repo.\n",
                    style: _bodyStyle),
                TextSpan(text: "Also,\n", style: _headingStyle),
                TextSpan(
                    text:
                        "There might be options for donating to each recipe contributor at contribution section of each recipe.\n",
                    style: _bodyStyle),
                TextSpan(text: "Finally,\n", style: _headingStyle),
                    TextSpan(
                        text:
                        "Source code for this app is",
                        style: _bodyStyle),
                    TextSpan(
                        text: " here. ",
                        style: _bodyStyle.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch("https://github.com/Binabh/based-cooking-app");
                          }),
                    TextSpan(
                        text:
                        "Please feel free to discuss about bugs and features in issues of the repo. ",
                        style: _bodyStyle),
                TextSpan(
                    text:
                        "You can also donate to me (the app developer). Details are",
                    style: _bodyStyle),
                TextSpan(
                    text: " here.\n",
                    style: _bodyStyle.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://binabh.com.np/donate");
                      }),
              ]))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BasedColors.lightBlack,
        appBar: AppBar(
          backgroundColor: BasedColors.lightBlack,
          elevation: 0,
          title: searchMode
              ? TextFormField(
                  style: const TextStyle(color: BasedColors.white),
                  autofocus: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: BasedColors.tomato,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: BasedColors.tomato, width: 1)),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: BasedColors.tomato, width: 1))),
                  onChanged: (value) {
                    _deBouncer.run(() {
                      setState(() {
                        title = value;
                      });
                    });
                  },
                )
              : const Center(
                  child: Text(
                    "🍲 Based Cooking 🍳",
                    style: TextStyle(color: BasedColors.white),
                  ),
                ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await getFilesRepository.getAllRecipes(forceUpdate: true);
            },
            child: StreamBuilder<List<Recipe>>(
                stream: db.recipeDao.watchAllRecipes(title, tag),
                builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
                  List<Recipe> recipePaths = [];
                  if (snapshot.hasData) {
                    recipePaths = snapshot.data!;
                  }
                  return ListView.builder(
                      itemCount: recipePaths.length,
                      itemBuilder: (_, index) {
                        String filename = recipePaths[index].filename;
                        String title = recipePaths[index].title;
                        List<String> tags = recipePaths[index].tags.split("|");
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return RecipePage(filepath: filename);
                            }));
                          },
                          child: Card(
                            shadowColor: BasedColors.tomato,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: BasedColors.tomato, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            color: BasedColors.black,
                            margin: const EdgeInsets.only(
                                left: 8, top: 8, bottom: 0, right: 8),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, left: 8.0, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MarkdownBody(
                                    data: title,
                                    styleSheet: MarkdownStyleSheet(
                                        h1: markdownStyleSheet.h1!
                                            .copyWith(fontSize: 18)),
                                  ),
                                  Wrap(
                                      children: tags.map((e) {
                                    bool activeTag =
                                        tag.isNotEmpty && e.contains(tag);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (activeTag) {
                                            setState(() {
                                              tag = "";
                                            });
                                          } else {
                                            setState(() {
                                              tag = e;
                                            });
                                          }
                                        },
                                        child: Chip(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: activeTag
                                                      ? BasedColors.tomato
                                                      : BasedColors.white,
                                                  width: activeTag ? 1 : 0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16))),
                                          label: Text(
                                            e,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          backgroundColor: activeTag
                                              ? BasedColors.tomato
                                                  .withOpacity(0.4)
                                              : BasedColors.white,
                                          elevation: 1,
                                        ),
                                      ),
                                    );
                                  }).toList()),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ),
        floatingActionButton: SpeedDial(
          renderOverlay: false,
          backgroundColor: BasedColors.tomato,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              label: searchMode ? "Close Search" : "Search",
              child: searchMode
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          title = "";
                          searchMode = false;
                        });
                      },
                      icon: const Icon(Icons.cancel))
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          searchMode = true;
                        });
                      },
                    ),
            ),
            SpeedDialChild(
                child: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    _info();
                  },
                ),
                label: "About"),
          ],
        ));
  }
}
