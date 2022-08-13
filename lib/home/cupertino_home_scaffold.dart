import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold(
      {Key? key,
      required this.currentTab,
      required this.onSelectTab,
      required this.widgetBuilder,
      required this.navigatorKeys})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab; //ValueChanged type
  final Map<TabItem, WidgetBuilder> widgetBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>>
      navigatorKeys; //WidgetBuilder type
  //WillPopScope with  GlobalKey<NavigatorState> Solve BAckButton close the app instead of back

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        //activeColor: Colors.green,
        // it works by default color main theme green
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index) {
          onSelectTab(TabItem.values[index]);
          debugPrint('${TabItem.values[index]}');
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          //WillPopScope with  GlobalKey<NavigatorState> Solve BAckButton close the app instead of back
          navigatorKey: navigatorKeys[TabItem.values[index]],
          builder: (context) {
            return widgetBuilder[TabItem.values[index]]!(context);
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    //final color = currentTab == tabItem ? Colors.lightGreen : Colors.grey;
    // use activeColor: inside CupertinoTabBar
    return BottomNavigationBarItem(
      //backgroundColor: color,
      icon: Icon(
        itemData?.icon,
        // color: color
      ),
      label: itemData?.title,
    );
  }
}
