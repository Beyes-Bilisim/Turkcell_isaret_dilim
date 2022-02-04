import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/api/MovieApi.dart';
import 'package:movie_manager/models/Movie.dart';
import 'package:movie_manager/pages/Details.dart';
import 'package:movie_manager/pages/DetailsWithoutImage.dart';
import 'package:movie_manager/pages/Login.dart';
import 'package:movie_manager/utils/texts/Texts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(Texts.search_page_title),
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
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(Texts.logout),
                    content: Text(Texts.logout_question),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _auth.signOut();
                            WidgetsBinding.instance!
                                .addPostFrameCallback((timeStamp) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                  (r) => false);
                            });
                          },
                          child: Text(Texts.logout_yes)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
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
              hintText: Texts.search_label_text,
              hintStyle: style,
              border: InputBorder.none,
            ),
            onChanged: (text) async {
              var gelenMovies = await api.getMovies(text);
              setState(() {
                query = text;
                movies = gelenMovies;
              });
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
