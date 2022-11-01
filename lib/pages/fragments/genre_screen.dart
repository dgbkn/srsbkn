import 'dart:convert';

import 'package:srsbkn/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:srsbkn/pages/api/apiEndpoints.dart';
import 'package:srsbkn/pages/songs_pages/GenreSongs.dart';
import 'package:srsbkn/theme/app_theme.dart';
import 'package:http/http.dart' as http;

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  late ThemeData theme;

  double findAspectRatio(double width) {
    //Logic for aspect ratio of grid view
    return (width / 2 - 24) / ((width / 2 - 24) + 35);
  }

  List<Widget> rows = <Widget>[];

  Widget _buildSinglegenre(genre, context) {
    theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GenreSongs(
                    genre_id: genre["id"],
                    genre_name: genre["cateogry_name"])));
      },
      child: FxContainer.bordered(
        color: Colors.transparent,
        paddingAll: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: genre["id"],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      genre["background_thumb"],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FxText.bodyLarge(genre["cateogry_name"],
                      fontWeight: 700, letterSpacing: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future loadData() async {
    var data = await http.get(getApiUrl("getgenres.php"));

    var gotData = jsonDecode(data.body);

    rows = <Widget>[];

    if (gotData.length == 0) {
      rows.add(Container(
        child: const Center(child: Text("Nothing Found on server")),
      ));
    } else {
      gotData["data"].forEach((data) {
        rows.add(_buildSinglegenre(data, context));
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    theme = AppTheme.learningTheme;
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rows.length == 0) {
      return Scaffold(
        body: LoadingEffect.getSearchLoadingScreen(
          context,
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          padding: FxSpacing.zero,
          children: [
            FxSpacing.height(20),
            Padding(
              padding: FxSpacing.x(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.labelMedium(
                    'Genres',
                    fontWeight: 700,
                  ),
                  Icon(
                    FeatherIcons.moreHorizontal,
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            Padding(
              padding: FxSpacing.x(20),
              child: GridView.count(
                padding: FxSpacing.zero,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio:
                    findAspectRatio(MediaQuery.of(context).size.width),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: rows,
              ),
            ),
          ],
        ),
      );
    }
  }
}
