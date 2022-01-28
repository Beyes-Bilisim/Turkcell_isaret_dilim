import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_manager/models/Movie.dart';

class DetailsWithOutImage extends StatefulWidget {
  late Movie movie;
    final int index;
  final ValueChanged<int> onChangeTab;
  DetailsWithOutImage({
    Key? key,
    required this.movie,
    required this.index,
    required this.onChangeTab,
  }) : super(key: key);

  @override
  _DetailsWithOutImageState createState() => _DetailsWithOutImageState();
}

class _DetailsWithOutImageState extends State<DetailsWithOutImage> {
  @override
  Widget build(BuildContext context) {
    var tarihList = this.widget.movie.releaseDate.split("-");

    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BuildTabItem(index: 0, icon: Icon(Icons.format_list_bulleted)),
            BuildTabItem(index: 1, icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text('${widget.movie.title}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.cyan],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Center(
            child: Text(widget.movie.title + " (${tarihList[0]})",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        Padding(
            padding: EdgeInsets.all(20),
            child: Text(widget.movie.overview, style: TextStyle(fontSize: 18)))
      ])),
    );
  }
  Widget BuildTabItem({required int index, required Icon icon}) {
    final isSelected = index == widget.index;
    return IconTheme(
        data: IconThemeData(
          color: Colors.blue,
        ),
        child: IconButton(
            onPressed: () {
              if (index == 0) {
                print("listeye ekleniyor");
              } else if (index == 1) {
                print("favorite ekleniyor");
              }
            },
            icon: icon));
  }
}
