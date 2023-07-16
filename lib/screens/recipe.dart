import 'dart:io';

import 'package:basedcooking/constants/api_endpoints.dart';
import 'package:basedcooking/constants/colors.dart';
import 'package:basedcooking/constants/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecipePage extends StatefulWidget {
  final String filepath;

  const RecipePage({Key? key, required this.filepath}) : super(key: key);

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BasedColors.lightBlack,
        body: SafeArea(
            child: Card(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: BasedColors.tomato, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: BasedColors.black,
          margin: const EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 8),
          elevation: 1,
          child: Markdown(
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubWeb.blockSyntaxes,
              [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
            ),
            styleSheet: markdownStyleSheet,
            imageBuilder: (uri, b, c) {
              return CachedNetworkImage(
                imageUrl: uri.toString(),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              );
            },
            data: File(widget.filepath)
                .readAsStringSync()
                .replaceAll('(/pix/', '(${ApiEndpoint.rawPixUrl}')
                .replaceFirst("---", "")
                .replaceFirst("title:", "# ")
                .replaceFirst('"', '')
                .replaceFirst('"', '')
                .replaceFirst("date:", "🗓")
                .replaceFirst(RegExp(r'tags\s*:\s*\[([^\]]+)\]'), "")
                .replaceFirst("author:", "🧑‍🍳")
                .replaceFirst("---", ""),
            selectable: true,
            onTapLink: (text, link, title) async {
              Directory appDir = await getApplicationDocumentsDirectory();
              if (link == null) {
                return;
              } else if (!link.contains("https://")) {
                String filename = link.split(".").first;
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return RecipePage(filepath: '${appDir.path}/$filename.md');
                }));
              } else if (link.contains("https://based.cooking/")) {
                String filename = link.split('/').last;
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return RecipePage(filepath: '${appDir.path}/$filename.md');
                }));
              } else {
                launchUrlString(link);
              }
            },
          ),
        )));
  }
}
