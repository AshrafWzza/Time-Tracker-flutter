import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/home/account/account_page.dart';
import 'package:time_tracker_flutter/home/tab_item.dart';
import 'package:time_tracker_flutter/home/jobs/jobs_page.dart';
import 'cupertino_home_scaffold.dart';

//ToDo: Back Button does Not work with CupertinoTabScaffold, it close the App
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentItem = TabItem.jobs;
  //WillPopScope with  GlobalKey<NavigatorState> Solve BAckButton close the app instead of back
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, WidgetBuilder> get widgetBuilder {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  //No need to use select method, it works properly without it
  void _select(TabItem tabItem) {
    if (tabItem == _currentItem) {
      //Pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentItem = tabItem;
        debugPrint('$_currentItem');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //WillPopScope with  GlobalKey<NavigatorState> Solve BAckButton close the app instead of back
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentItem]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentItem,
        onSelectTab: (value) {
          _select(value);
        },
        widgetBuilder: widgetBuilder,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
