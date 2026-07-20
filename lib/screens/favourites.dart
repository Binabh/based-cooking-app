import 'package:basedcooking/base/database.dart';
import 'package:basedcooking/constants/colors.dart';
import 'package:basedcooking/constants/theme.dart';
import 'package:basedcooking/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasedColors.lightBlack,
      appBar: AppBar(
        backgroundColor: BasedColors.lightBlack,
        elevation: 0,
        iconTheme: const IconThemeData(color: BasedColors.tomato),
        title: const Text(
          "❤️ Favourites",
          style: TextStyle(color: BasedColors.white),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Recipe>>(
          stream: db.recipeDao.watchFavouriteRecipes(),
          builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: BasedColors.tomato.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No favourites yet",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: BasedColors.white.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the heart icon on any recipe to add it here",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontSize: 13,
                            color: BasedColors.white.withOpacity(0.4),
                          ),
                    ),
                  ],
                ),
              );
            }
            List<Recipe> favourites = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ListView.builder(
                itemCount: favourites.length,
                itemBuilder: (_, index) {
                  String filename = favourites[index].filename;
                  String title = favourites[index].title;
                  List<String> tags = favourites[index].tags.split("|");
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
                            BorderRadius.all(Radius.circular(10)),
                      ),
                      color: BasedColors.black,
                      margin: const EdgeInsets.only(
                          left: 8, top: 8, bottom: 0, right: 8),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 8.0, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  MarkdownBody(
                                    data: title,
                                    styleSheet: MarkdownStyleSheet(
                                      h1: markdownStyleSheet.h1!
                                          .copyWith(fontSize: 18),
                                    ),
                                  ),
                                  Wrap(
                                    children: tags.map((e) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Chip(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                          label: Text(
                                            e,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          backgroundColor: BasedColors.white,
                                          elevation: 1,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                db.recipeDao.toggleFavourite(
                                    filename, true);
                              },
                              icon: const Icon(
                                Icons.favorite,
                                color: BasedColors.tomato,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
