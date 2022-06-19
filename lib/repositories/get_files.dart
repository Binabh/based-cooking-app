import 'dart:io';

import 'package:based_cooking/base/database.dart';
import 'package:based_cooking/base/repository.dart';
import 'package:based_cooking/models/recipe_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class GetFilesRepository extends BaseRepository {
  getAllRecipes({bool forceUpdate = false}) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    Response response =
        await getDataFromServer("/master", forceRefresh: forceUpdate);
    List<RecipeFile> treeList = [
      for (var jsonObject in response.data['tree'])
        RecipeFile.fromJson(jsonObject)
    ];
    String srcSHA =
        treeList.firstWhere((element) => element.path == 'content').sha;
    response = await getDataFromServer('/$srcSHA', forceRefresh: forceUpdate);
    List<RecipeFile> recipeFiles = [
      for (var jsonObject in response.data['tree'])
        RecipeFile.fromJson(jsonObject)
    ];
    List<String> recipePathList = [];
    for (RecipeFile recipeFile in recipeFiles) {
      recipePathList.add(appDir.path + '/${recipeFile.path}');
      if (File(appDir.path + '/${recipeFile.path}').existsSync()) {
        if (File(appDir.path + '/${recipeFile.path}').statSync().size ==
            recipeFile.size) {
          // TODO: check SHA sum and download file if different
        } else {
          downloadFile(recipeFile.path, appDir.path);
        }
      } else {
        downloadFile(recipeFile.path, appDir.path);
      }
    }
    if (recipePathList.isNotEmpty) {
      List<Recipe> dbRecipes = await db.recipeDao.getAllRecipes();
      for (Recipe recipe in dbRecipes) {
        if (!recipePathList.contains(recipe.filename)) {
          deleteFile(recipe);
        }
      }
    }
  }

  downloadFile(String filename, String savePath) async {
    if (filename == "_index.md") return;
    bool success = await getFileFromServer("/$filename",
        savePath: savePath + "/$filename");
    if (success) {
      List<String> recipe = await File(savePath + "/$filename").readAsLines();
      String title = recipe
          .firstWhere((element) => element.contains("title:"))
          .split(":")
          .last
          .replaceAll('"', "");
      String tagline =
          recipe.firstWhere((element) => element.contains("tags:"));
      List<String> tags = tagline
          .split(":")
          .last
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll("'", "")
          .split(",");
      tags.removeWhere((element) => element.isEmpty);
      for (var element in tags) {
        element.trim();
      }
      String tagString = tags.join("|");
      db.recipeDao.insertRecipe(RecipesCompanion.insert(
          filename: savePath + '/$filename', title: '# $title', tags: tagString));
    }
  }

  deleteFile(Recipe recipe) async {
    await db.recipeDao.deleteRecipe(recipe);
    await File(recipe.filename).delete();
  }
}

GetFilesRepository getFilesRepository = GetFilesRepository();
