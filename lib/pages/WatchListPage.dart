import 'package:flutter/material.dart';
import 'package:movie_manager/api/MovieApi.dart';
import 'package:movie_manager/widgets/MovieCard.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({Key? key}) : super(key: key);

  @override
  _WatchListPageState createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  MovieApi api = MovieApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text('WatchList'),
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
        child: Column(
          children: [
            FutureBuilder(
              future: api.getWatchList(),
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
            )
          ],
        ),
      ),
    );
  }
}
