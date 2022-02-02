import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:movie_manager/models/Movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  late Movie movie;
  final int index;
  final ValueChanged<int> onChangeTab;
  Details({
    Key? key,
    required this.movie,
    required this.index,
    required this.onChangeTab,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
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
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
              height: 300,
              width: 500,
              child: Stack(children: [
                (widget.movie.backdropPath != null)
                    ? Image.network("http://image.tmdb.org/t/p/w500/" +
                        widget.movie.backdropPath)
                    : (widget.movie.posterPath != null)
                        ? Image.network("http://image.tmdb.org/t/p/w500/" +
                            widget.movie.posterPath)
                        : Text(""),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_purple500_outlined,
                            color: Colors.yellow,
                            size: 18,
                          ),
                          Text(
                            "${widget.movie.voteAverage}",
                            style:
                                TextStyle(fontSize: 18, color: Colors.yellow),
                          ),
                        ],
                      ),
                    ]),
              ])),
          Center(
              child: Text(widget.movie.title + " (${tarih})",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
          Padding(
              padding: EdgeInsets.all(20),
              child:
                  Text(widget.movie.overview, style: TextStyle(fontSize: 18)))
        ],
      )),
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
                  print("listeye ekleniyor");
                  list.add(widget.movie.id.toString());
                  list_offline!.add(movieToJson(widget.movie));
                  sharedPreferences.setStringList("list", list);
                  sharedPreferences.setStringList("list_offline", list_offline);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text('İzleme Listesine Eklendi'),
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
                    content: const Text('izleme listenizden çıkarıldı'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              if (index == 1) {
                if (!favoricindemi) {
                  print("favorite ekleniyor");
                  favorites.add(widget.movie.id.toString());
                  favorites_offline!.add(movieToJson(widget.movie));
                  sharedPreferences.setStringList("favorites", favorites);
                  sharedPreferences.setStringList(
                      "favorites_offline", favorites_offline);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text('Favorilerinize eklendi'),
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
                    content: const Text('favorilerinizden çıkarıldı'),
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
