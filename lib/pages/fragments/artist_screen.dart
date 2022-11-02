import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:srsbkn/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:srsbkn/pages/api/apiEndpoints.dart';
import 'package:srsbkn/pages/songs_pages/ArtistSongs.dart';
import 'package:srsbkn/theme/app_theme.dart';
import 'package:http/http.dart' as http;

// import '../../../theme/constant.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({Key? key}) : super(key: key);

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  late ThemeData theme;

  List<Widget> rows = <Widget>[];

  Widget _buildSingleArtist(artist) {
    return FxContainer(
      margin: FxSpacing.bottom(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArtistSongs(
                    artist_id: artist["id"],
                    artist_name: artist["name"],
                  )),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FxContainer(
            paddingAll: 0,
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
                imageUrl: artist["avatar"],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 80,
                width: 80,
                fit: BoxFit.fill),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyLarge(
                      artist["name"],
                      fontWeight: 600,
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
                      "Artist",
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
    var data = await http.get(getApiUrl("getartists.php"));

    var gotData = jsonDecode(data.body);

    rows = <Widget>[];

    if (gotData.length == 0) {
      rows.add(Container(
        child: const Center(child: Text("Nothing Found on server")),
      ));
    } else {
      gotData["data"].forEach((data) {
        rows.add(_buildSingleArtist(data));
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
                    'Meet The Masters 🎭',
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
