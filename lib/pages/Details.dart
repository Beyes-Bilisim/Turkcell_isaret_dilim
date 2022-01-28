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
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
              height: 300,
              width: 500,
              child: Stack(children: [
                Image.network((widget.movie.backdropPath != null)
                    ? "http://image.tmdb.org/t/p/w500/" +
                        widget.movie.backdropPath
                    : "http://image.tmdb.org/t/p/w500/" +
                        widget.movie.posterPath),
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
                      // Text("${tarih}",
                      //     style: TextStyle(fontSize: 18, color: Colors.white)),
                    ]),
              ])),
          Center(
              child: Text(widget.movie.title + " (${tarihList[0]})",
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
              var list = sharedPreferences.getStringList("list");
              var movie = widget.movie.id.toString();
              bool liste = false;
              bool favorite = false;
              for (var i in list!) {
                if (i == movie) {
                  liste = true;
                }
              }
              for (var x in favorites!) {
                if (x == movie) {
                  favorite = true;
                }
              }
              if (!liste && !favorite) {
                if (index == 0) {
                  print("listeye ekleniyor");
                  list.add(widget.movie.id.toString());
                  print(list);
                  sharedPreferences.setStringList("list", list);
                  final snackBar = SnackBar(
                    content: const Text('İzleme Listesine Eklendi'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (index == 1) {
                  print("favorite ekleniyor");
                  favorites.add(widget.movie.id.toString());
                  sharedPreferences.setStringList("favorites", favorites);
                  final snackBar = SnackBar(
                    content: const Text('Favorilerinize eklendi'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              if (liste) {
                list.remove(widget.movie.id.toString());
                sharedPreferences.setStringList("list", list);

                final snackBar = SnackBar(
                  content: const Text('izleme listenizden çıkarıldı'),
                  backgroundColor: (Colors.black12),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              if (favorite) {
                favorites.remove(widget.movie.id.toString());
                sharedPreferences.setStringList("favorites", favorites);
                final snackBar = SnackBar(
                  content: const Text('favorilerinizden çıkarıldı'),
                  backgroundColor: (Colors.black12),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: icon));
  }
}
