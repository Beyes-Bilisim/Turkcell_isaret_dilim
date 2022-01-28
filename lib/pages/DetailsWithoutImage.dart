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
              print("index :$index");
              var sharedPreferences = await SharedPreferences.getInstance();
              var favorites = sharedPreferences.getStringList("favorites");
              var list = sharedPreferences.getStringList("list");
              var movie = widget.movie.id.toString();

              bool listeicindemi = icindeMi(movie, list!);
              bool favoricindemi = icindeMi(movie, favorites!);
              if (!listeicindemi && !favoricindemi) {
                if (index == 0) {
                  print("listeye ekleniyor");
                  list.add(widget.movie.id.toString());
                  print(list);
                  sharedPreferences.setStringList("list", list);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text('İzleme Listesine Eklendi'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (index == 1) {
                  print("favorite ekleniyor");
                  favorites.add(widget.movie.id.toString());
                  sharedPreferences.setStringList("favorites", favorites);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text('Favorilerinize eklendi'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } else {
                if (listeicindemi) {
                  list.remove(widget.movie.id.toString());
                  sharedPreferences.setStringList("list", list);
                  listeicindemi = false;
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: const Text('izleme listenizden çıkarıldı'),
                    backgroundColor: (Colors.black12),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (favoricindemi) {
                  favorites.remove(widget.movie.id.toString());
                  sharedPreferences.setStringList("favorites", favorites);
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
