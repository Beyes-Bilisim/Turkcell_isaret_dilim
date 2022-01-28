import 'package:flutter/material.dart';
import 'package:movie_manager/models/Movie.dart';
import 'package:movie_manager/pages/Details.dart';

class MovieCard extends StatefulWidget {
  late Movie movie;
  final subtitle;
  final image;
  MovieCard({Key? key, required this.movie, required this.subtitle, this.image})
      : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        child: ListTile(
          leading:
              Image.network("http://image.tmdb.org/t/p/w500/${widget.image}"),
          title: Text("${widget.movie.title}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("${widget.subtitle}"),
          ]),
        ),
        onTap: () {
         Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            movie: widget.movie,
                            index: index,
                            onChangeTab: onChangeTab,
                          ),
                        ));
        },
      ),
    );
  }
  void onChangeTab(int value) {
    setState(() {
      print(index);
      index = value;
    });
  }
}
