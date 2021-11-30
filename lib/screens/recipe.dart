import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  final String filepath;

  const RecipePage({Key? key, required this.filepath}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Markdown(
              styleSheet: MarkdownStyleSheet(),
              imageBuilder: (uri,b,c){
                return CachedNetworkImage(
                  imageUrl: uri.toString(),
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                );
              },
      data: File(widget.filepath).readAsStringSync().replaceAll('(pix/', '(https://based.cooking/pix/'),
      selectable: true,
      onTapLink: (text, link, title) async {
        Directory appDir = await getApplicationDocumentsDirectory();
        if(link == null){
          return;
        }
        else if (!link.contains("https://")) {
          String filename = link.split(".").first;
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return RecipePage(filepath: appDir.path+'/$filename.md');
          }));
        } else if (link.contains("https://based.cooking/")) {
          String filename = link.split('/').last;
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return RecipePage(filepath: appDir.path+'/$filename.md');
          }));
        } else {
          launch(link);
        }
      },
    )));
  }
}
