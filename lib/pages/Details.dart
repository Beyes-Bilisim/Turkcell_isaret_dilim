import 'package:flutter/material.dart';

import 'package:movie_manager/models/Movie.dart';

class Details extends StatefulWidget {
  late Movie movie;
  Details({
    Key? key,
    required this.movie,
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
}
