import 'package:flutter/material.dart';
import 'package:movie_manager/utils/texts/Texts.dart';
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
    var tarih;
    try {
      tarih = this.widget.movie.releaseDate.split("-")[0];
    } catch (e) {
      tarih = "null";
    }
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
        SizedBox(
          height: 150,
        ),
        Center(
            child: Text(widget.movie.title + " (${tarih})",
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
            onPressed: () async {
              var sharedPreferences = await SharedPreferences.getInstance();
              var favorites = sharedPreferences.getStringList("favorites");
              var favorites_offline =
                  sharedPreferences.getStringList("favorites_offline");
              var list = sharedPreferences.getStringList("list");
              var list_offline =
                  sharedPreferences.getStringList("list_offline");
              var movie = widget.movie.id.toString();

              bool listeicindemi = icindeMi(movie, list!);
              bool favoricindemi = icindeMi(movie, favorites!);
              if (index == 0) {
                if (!listeicindemi) {
                  list.add(widget.movie.id.toString());
                  list_offline!.add(movieToJson(widget.movie));
                  sharedPreferences.setStringList("list", list);
                  sharedPreferences.setStringList("list_offline", list_offline);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content:  Text(Texts.added_to_watch_list),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  list.remove(widget.movie.id.toString());
                  list_offline!.remove(movieToJson(widget.movie));
                  sharedPreferences.setStringList("list", list);
                  sharedPreferences.setStringList("list_offline", list_offline);
                  listeicindemi = false;
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content:  Text(Texts.removed_from_watch_list),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              if (index == 1) {
                if (!favoricindemi) {
                  favorites.add(widget.movie.id.toString());
                  favorites_offline!.add(movieToJson(widget.movie));
                  sharedPreferences.setStringList("favorites", favorites);
                  sharedPreferences.setStringList(
                      "favorites_offline", favorites_offline);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content:  Text(Texts.added_to_favorites),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  favorites.remove(widget.movie.id.toString());
                  favorites_offline!.remove(movieToJson(widget.movie));
                  sharedPreferences.setStringList("favorites", favorites);
                  sharedPreferences.setStringList(
                      "favorites_offline", favorites_offline);
                  favoricindemi = false;
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content:  Text(Texts.removed_from_favorites),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            icon: icon));
  }

  icindeMi(String str, List list) {
    bool icinde = false;
    for (var i in list) {
      if (i == str) {
        icinde = true;
      }
    }
    return icinde;
  }
}
