import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/api/Api.dart';
import 'package:movie_manager/models/Movie.dart';
import 'package:movie_manager/pages/Details.dart';
import 'package:movie_manager/pages/DetailsWithoutImage.dart';

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
  ConnectivityResult? _connectivityResult;

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
  }

  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivityState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        child: ListTile(
          leading: (widget.image == null)
              ? null
              : _connectivityResult == ConnectivityResult.none
                  ? Icon(Icons.wifi_off)
                  : Image.network(
                      "${Api.imageUrl}${widget.image}"),
          title: Text("${widget.movie.title}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(widget.subtitle ?? "null"),
          ]),
        ),
        onTap: () {
          if (_connectivityResult == ConnectivityResult.none) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsWithOutImage(
                    movie: widget.movie,
                    index: index,
                    onChangeTab: onChangeTab,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(
                    movie: widget.movie,
                    index: index,
                    onChangeTab: onChangeTab,
                  ),
                ));
          }
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
