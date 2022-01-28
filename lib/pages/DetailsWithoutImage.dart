import 'package:flutter/material.dart';

import 'package:movie_manager/models/Movie.dart';

class DetailsWithOutImage extends StatefulWidget {
  late Movie movie;
  DetailsWithOutImage({
    Key? key,
    required this.movie,
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
}
