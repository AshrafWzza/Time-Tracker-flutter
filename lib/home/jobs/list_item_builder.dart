import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/home/jobs/empty_content.dart';

// Create new Type
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      //1 Data UI State
      final List<T> items = snapshot.data!;
      if (items.isNotEmpty) {
        // 2 Empty UI State
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      //reverse: true,
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) // First & Last of list
        //index of last one always be list.length-1  -so items.length+2-1 =  items.length1
        {
          return Container();
        }
        return itemBuilder(context, items[index - 1]); //Mandatory -1
      },
    );
  }
}
