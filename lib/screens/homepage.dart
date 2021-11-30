import 'package:based_cooking/base/database.dart';
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
      appBar: AppBar(
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
            : const Text("Based Recipes"),
      ),
      body: RefreshIndicator(
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
                        margin: const EdgeInsets.only(
                            left: 8, top: 4, bottom: 4, right: 8),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: title,
                                styleSheet: MarkdownStyleSheet(
                                    h1: const TextStyle(fontSize: 18)),
                              ),
                              Wrap(
                                  children: tags.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (e == tag) {
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
                                      label: Text(
                                        e,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: tag.isEmpty
                                          ? Colors.white
                                          : e.contains(tag)
                                              ? Colors.purpleAccent
                                                  .withOpacity(0.6)
                                              : Colors.white,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
