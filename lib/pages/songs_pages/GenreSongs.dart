import 'dart:convert';

import 'package:srsbkn/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:srsbkn/pages/api/apiEndpoints.dart';
import 'package:srsbkn/pages/player/main_player.dart';
import 'package:srsbkn/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:srsbkn/theme/theme_type.dart';

// import '../../../theme/constant.dart';

class GenreSongs extends StatefulWidget {
  final String genre_id;
  final String genre_name;
  const GenreSongs({required this.genre_id, required this.genre_name});

  @override
  _GenreSongsState createState() => _GenreSongsState();
}

class _GenreSongsState extends State<GenreSongs> {
  late ThemeData theme;

  List<Widget> rows = <Widget>[];

  Widget _buildSingleSong(song) {
    return FxContainer(
      margin: FxSpacing.bottom(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MusicPlayer(
                    songInfo: song,
                  )),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FxContainer(
            paddingAll: 0,
            clipBehavior: Clip.hardEdge,
            child: Image(
              height: 80,
              width: 80,
              fit: BoxFit.fill,
              image: AssetImage("assets/gurujii.jpg"),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FxText.bodyLarge(
                        song["title"],
                        fontWeight: 600,
                      ),
                    ),
                    // Icon(
                    //   FeatherIcons.heart,
                    //   color: theme.colorScheme.primary,
                    //   size: 20,
                    // ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description,
                      color: theme.colorScheme.onBackground.withAlpha(140),
                      size: 16,
                    ),
                    FxSpacing.width(8),
                    Expanded(
                        child: FxText.bodySmall(
                      song["description"],
                      xMuted: true,
                    )),
                  ],
                ),
                FxSpacing.height(6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future loadData() async {
    if (!mounted) return;

    var data = await http
        .get(getApiUrl("getgenresongs.php?genre_id=${widget.genre_id}"));

    var gotData = jsonDecode(data.body);

    rows = <Widget>[];

    if (gotData.length == 0) {
      rows.add(Container(
        child: const Center(child: Text("Nothing Found on server")),
      ));
    } else {
      gotData["data"].forEach((data) {
        rows.add(_buildSingleSong(data));
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

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    isDark = AppTheme.themeType == ThemeType.dark;
    AppBar aapBar = AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_sharp,
              color: isDark ? Colors.white : Colors.black)),
      title: Text(widget.genre_name,
          style: TextStyle(color: isDark ? Colors.white : Colors.black)),
    );

    
    if (rows.length == 0) {
      return Scaffold(
        appBar: aapBar,
        body: LoadingEffect.getSearchLoadingScreen(
          context,
        ),
      );
    } else {
      return Scaffold(
        appBar: aapBar,
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
                    'CLIPS IN ' + widget.genre_name,
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
              child: Column(
                children: rows,
              ),
            ),
          ],
        ),
      );
    }
  }
}
