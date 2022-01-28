import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangeTab;
  const TabBarWidget({Key? key, required this.index, required this.onChangeTab})
      : super(key: key);

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BuildTabItem(index: 0, icon: Icon(Icons.local_movies_sharp)),
          BuildTabItem(index: 1, icon: Icon(Icons.format_list_bulleted)),
          BuildTabItem(index: 2, icon: Icon(Icons.favorite)),
        ],
      ),
    );
  }

  Widget BuildTabItem({required int index, required Icon icon}) {
    final isSelected = index == widget.index;
    return IconTheme(
        data: IconThemeData(color: isSelected ? Colors.blue : Colors.black),
        child:
            IconButton(onPressed: () => widget.onChangeTab(index), icon: icon));
  }
}
