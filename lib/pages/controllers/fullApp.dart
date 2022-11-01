import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/icons/box_icon/box_icon_data.dart';

class NavItem {
  final String title;
  final IconData activeIconData, inactiveIconData;

  NavItem(this.title, this.activeIconData, this.inactiveIconData);
}

class FullAppController extends FxController {
  int currentIndex = 0;
  int pages = 4;
  late TabController tabController;

  final TickerProvider tickerProvider;

  late List<NavItem> navItems;

  FullAppController(this.tickerProvider) {
    tabController =
        TabController(length: pages, vsync: tickerProvider, initialIndex: 0);
    navItems = [
      NavItem('Home', FxBoxIcons.bxs_home, FxBoxIcons.bx_home),
      NavItem('Artists', FxBoxIcons.bxs_user, FxBoxIcons.bx_user),
      NavItem('Genres', FxBoxIcons.bxs_category, FxBoxIcons.bxs_category),
      NavItem('Search', Icons.search, Icons.search),
    ];
  }

  @override
  void initState() {
    super.initState();

    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }

  void changePage(int index) {
    tabController.animateTo(index);
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return 'full_app_controller';
  }
}
