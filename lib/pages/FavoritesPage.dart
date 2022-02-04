import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/api/MovieApi.dart';
import 'package:movie_manager/utils/texts/Texts.dart';
import 'package:movie_manager/widgets/MovieCard.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  ConnectivityResult? _connectivityResult;

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
  }

  MovieApi api = MovieApi();

  @override
  initState() {
    super.initState();
    _checkConnectivityState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(Texts.favorites_page_title),
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
      body: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: api.getFavorites(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (snapshot.data as List).length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      subtitle: (snapshot.data as List)[index]
                              .releaseDate
                              .split("-")[0] ??
                          "null",
                      image: (snapshot.data as List)[index].posterPath ??
                          (snapshot.data as List)[index].backdropPath,
                      movie: (snapshot.data as List)[index],
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
