import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_manager/api/MovieApi.dart';
import 'package:movie_manager/models/Movie.dart';
import 'package:movie_manager/pages/Details.dart';
import 'package:movie_manager/pages/DetailsWithoutImage.dart';
import 'package:movie_manager/widgets/MovieCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text('Search'),
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
      body: Search(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  MovieApi api = MovieApi();
  int index = 0;
  TextEditingController _search = TextEditingController();
  List<Movie> movies = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = this.query.isEmpty ? styleHint : styleActive;
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _search,
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: style.color),
              suffixIcon: query.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close, color: style.color),
                      onTap: () {
                        _search.clear();

                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              hintText: "Search",
              hintStyle: style,
              border: InputBorder.none,
            ),
            onChanged: (text) async {
              var gelenMovies = await api.getMovies(text);
              setState(() {
                query = text;
                movies = gelenMovies;
              });
              // print(movies.length);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: (query.isEmpty) ? 0 : movies.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(movies[index].title),
                onTap: () {
                  if (movies[index].backdropPath == null &&
                      movies[index].posterPath == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsWithOutImage(
                            movie: movies[index],
                            index: index,
                            onChangeTab: onChangeTab,
                          ),
                        ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            movie: movies[index],
                            index: index,
                            onChangeTab: onChangeTab,
                          ),
                        ));
                  }
                },
              );
            },
          ))
          // MovieCard(),
        ],
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
