import 'package:based_cooking/base/database.dart';
import 'package:based_cooking/constants/colors.dart';
import 'package:based_cooking/repositories/get_files.dart';
import 'package:based_cooking/screens/recipe.dart';
import 'package:based_cooking/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasedColors.black,
      appBar: AppBar(
        backgroundColor: BasedColors.tomato,
        elevation: 0,
        leading: searchMode
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
        title: searchMode
            ? TextFormField(
                autofocus: true,
                decoration: const InputDecoration(fillColor: Colors.white),
                onChanged: (value) {
                  _deBouncer.run(() {
                    setState(() {
                      title = value;
                    });
                  });
                },
              )
            : const Text(
                "Based Recipes",
                style: TextStyle(color: BasedColors.white),
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
                                      h1: const TextStyle(
                                          fontSize: 18,
                                          color: BasedColors.lightBlue)),
                                ),
                                Wrap(
                                    children: tags.map((e) {
                                  bool activeTag =
                                      tag.isNotEmpty && e.contains(tag);
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
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
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: BasedColors.black,
                                              fontWeight: FontWeight.bold),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
