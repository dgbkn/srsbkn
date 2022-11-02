import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:srsbkn/pages/fragments/artist_screen.dart';
import 'package:srsbkn/pages/fragments/genre_screen.dart';
import 'package:srsbkn/pages/fragments/home_screen.dart';
import 'package:srsbkn/pages/fragments/search_screen.dart';
import 'package:srsbkn/pages/player/main_player.dart';

// theming
import 'package:srsbkn/theme/app_theme.dart';
import 'package:srsbkn/theme/theme_type.dart';
import 'package:srsbkn/theme/app_notifier.dart';
// theming

import 'controllers/fullApp.dart';
import 'package:provider/provider.dart';
import 'package:srsbkn/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class FullApp extends StatefulWidget {
  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> with SingleTickerProviderStateMixin {
  late ThemeData theme;
  late FullAppController controller;
  bool isDark = false;
                final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key


  @override
  void initState() {
    super.initState();
    theme = AppTheme.learningTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < controller.navItems.length; i++) {
      tabs.add(Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FxContainer(
              padding: FxSpacing.xy(16, 4),
              color: controller.currentIndex == i
                  ? theme.colorScheme.primary.withAlpha(80)
                  : Colors.transparent,
              borderRadiusAll: 24,
              child: Icon(
                controller.currentIndex == i
                    ? controller.navItems[i].activeIconData
                    : controller.navItems[i].inactiveIconData,
                size: 20,
                color: theme.colorScheme.onBackground,
              ),
            ),
            FxSpacing.height(4),
            FxText.bodySmall(controller.navItems[i].title,
                letterSpacing: 0,
                fontWeight: controller.currentIndex == i ? 700 : 500),
          ],
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    void changeTheme() {
      if (AppTheme.themeType == ThemeType.light) {
        Provider.of<AppNotifier>(context, listen: false)
            .updateTheme(ThemeType.dark);
      } else {
        Provider.of<AppNotifier>(context, listen: false)
            .updateTheme(ThemeType.light);
      }
      setState(() {});
    }

    void launchWebsite() async {
      String url = "https://srsbkn.ga/";
      await launchUrl(Uri.parse(url));
    }

    void launchAmritwani(context){
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicPlayer(
                  songInfo: {"title":"Amritwani","audio_location":"https://srsbkn.ga/upload/audio/2020/03/Voice%20038.opus","description":"अमृतवाणी"},
                )));
    }

    Widget _buildDrawer() {
      isDark = AppTheme.themeType == ThemeType.dark;

      return FxContainer.none(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        margin:
            FxSpacing.fromLTRB(16, FxSpacing.safeAreaTop(context) + 16, 16, 16),
        borderRadiusAll: 4,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
            child: Container(
          color: isDark ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding:
                    FxSpacing.only(left: 20, bottom: 24, top: 24, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      isDark ? "assets/home-logo-dark.png" : "assets/home-logo-light.png" ,
                    ),
                    FxSpacing.height(16),
                    FxContainer(
                      padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                      borderRadiusAll: 4,
                      color: theme.colorScheme.primary.withAlpha(40),
                      child: FxText.bodyMedium("जय श्री राम",
                          color: theme.colorScheme.primary,
                          fontWeight: 600,
                          letterSpacing: 0.2),
                    ),
                  ],
                ),
              ),
              FxSpacing.height(32),

                            Container(
                margin: FxSpacing.x(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => launchAmritwani(context),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        children: [
                          FxContainer(
                            paddingAll: 12,
                            borderRadiusAll: 4,
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: !isDark
                                  ? Icon(
                                      FeatherIcons.book,
                                      color: CustomTheme.orange,
                                    )
                                  : Icon(
                                      FeatherIcons.bookOpen,
                                      color: CustomTheme.orange,
                                    ),
                            ),
                            color: CustomTheme.orange.withAlpha(20),
                          ),
                          FxSpacing.width(16),
                          Expanded(
                            child: FxText.bodyLarge(
                              'Amritwani'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              FxSpacing.height(32),

              Container(
                margin: FxSpacing.x(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        changeTheme();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        children: [
                   FxContainer(
                            paddingAll: 12,
                            borderRadiusAll: 4,
                            color: CustomTheme.occur.withAlpha(20),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: !isDark
                                  ? Icon(
                                      FeatherIcons.moon,
                                      color: CustomTheme.occur,
                                    )
                                  : Icon(
                                      FeatherIcons.sunrise,
                                      color: CustomTheme.occur,
                                    ),
                            ),
                          ),
                          FxSpacing.width(16),
                          Expanded(
                            child: FxText.bodyLarge(
                              !isDark ? 'Dark Mode'.tr() : 'Light Mode'.tr(),
                            ),
                          ),
                          FxSpacing.width(16),
                          Icon(
                            FeatherIcons.chevronRight,
                            size: 18,
                            color: theme.colorScheme.onBackground,
                          ).autoDirection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FxSpacing.height(20),
              Divider(
                thickness: 1,
              ),
              FxSpacing.height(16),
              Container(
                margin: FxSpacing.x(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        launchWebsite();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        children: [
                          FxContainer(
                            paddingAll: 12,
                            borderRadiusAll: 4,
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: !isDark
                                  ? Icon(
                                      FeatherIcons.link,
                                      color: CustomTheme.skyBlue,
                                    )
                                  : Icon(
                                      FeatherIcons.link2,
                                      color: CustomTheme.skyBlue,
                                    ),
                            ),
                            color: CustomTheme.skyBlue.withAlpha(20),
                          ),
                          FxSpacing.width(16),
                          Expanded(
                            child: FxText.bodyLarge(
                              'Open Website'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      );
    }


    return FxBuilder<FullAppController>(
        controller: controller,
        builder: (shoppingFullAppController) {

          return Scaffold(
            drawer: _buildDrawer(),
            key: _key, // Assign the key to Scaffold.
            appBar: AppBar(
              elevation: 0,
              leading: FxContainer(
                color: Colors.transparent,
                margin: FxSpacing.left(4),
                onTap: () => _key.currentState!.openDrawer(),
                child: Icon(
                  FeatherIcons.menu,
                  size: 20,
                ),
              ),
              title: FxText.titleMedium(
                controller.navItems[controller.currentIndex].title
                    .toUpperCase(),
                fontWeight: 700,
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                FxSpacing.height(4),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: <Widget>[
                      HomeScreen(),
                      ArtistScreen(),
                      GenreScreen(),
                      SearchScreen()
                      // HomeScreen(),
                      // ExploreScreen(),
                      // ChatScreen(),
                      // ProfileScreen(),
                    ],
                  ),
                ),
                FxContainer(
                  borderRadiusAll: 0,
                  color: theme.colorScheme.primaryContainer.withAlpha(100),
                  child: TabBar(
                    controller: controller.tabController,
                    indicator: FxTabIndicator(
                      indicatorColor: Colors.transparent,
                      radius: 0,
                    ),
                    tabs: buildTab(),
                  ),
                )
              ],
            ),
          );
        });
  }
}
