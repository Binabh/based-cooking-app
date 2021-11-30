import 'dart:io';

import 'package:based_cooking/base/database.dart';
import 'package:based_cooking/base/repository.dart';
import 'package:based_cooking/models/recipe_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class GetFilesRepository extends BaseRepository {
  getAllRecipes({bool forceUpdate = false}) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    Response response = await getDataFromServer("/master", forceRefresh: forceUpdate);
    List<RecipeFile> treeList = [
      for (var jsonObject in response.data['tree'])
        RecipeFile.fromJson(jsonObject)
    ];
    String srcSHA = treeList.firstWhere((element) => element.path == 'src').sha;
    response = await getDataFromServer('/$srcSHA', forceRefresh: forceUpdate);
    List<RecipeFile> recipeFiles = [
      for (var jsonObject in response.data['tree'])
        RecipeFile.fromJson(jsonObject)
    ];
    for (RecipeFile recipeFile in recipeFiles) {
      if (File(appDir.path + '/${recipeFile.path}').existsSync()) {
        if (File(appDir.path + '/${recipeFile.path}').statSync().size ==
            recipeFile.size) {
        } else {
          await downloadFile(recipeFile.path, appDir.path);
        }
      } else {
        await downloadFile(recipeFile.path, appDir.path);
      }
    }
  }

  downloadFile(String filename, String savePath) async {
    bool success = await getFileFromServer("/$filename",
        savePath: savePath + "/$filename");
    if (success) {
      List<String> recipe = await File(savePath + "/$filename").readAsLines();
      String title = recipe.first;
      String tagline =
          recipe.firstWhere((element) => element.contains(";tags:"));
      List<String> tags = tagline.split(":").last.split(" ");
      tags.removeWhere((element) => element.isEmpty);
      String tagString = tags.join("|");
      db.recipeDao.insertRecipe(RecipesCompanion.insert(
          filename: savePath + '/$filename', title: title, tags: tagString));
    }
  }

  deleteFile(Recipe recipe) async {
    await db.recipeDao.deleteRecipe(recipe);
    await File(recipe.filename).delete();
  }
}

GetFilesRepository getFilesRepository = GetFilesRepository();
