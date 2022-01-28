import 'dart:convert';

import 'package:movie_manager/models/Movie.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieApi {
  Future<List<Movie>> getMovies(String query) async {
    final url = Uri.parse(
        "https://api.themoviedb.org/3/search/movie?api_key=260aea4b58c5eabb859359bb5581fdb7&language=tr&query=" +
            query);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("query : $query");
      var obj = json.decode(response.body);

      List<Movie> movies =
          (obj["results"] as List).map((e) => Movie.fromJson(e)).toList();
      return movies;
    } else {
      List<Movie> movies = [];
      return movies;
    }
  }

  Future<List<Movie>> getFavorites() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var favorites = sharedPreferences.getStringList("favorites");
    List<Movie> movies = [];
    print(favorites);
    for (String i in favorites!) {
      final url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$i?api_key=260aea4b58c5eabb859359bb5581fdb7&language=tr");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        movies.add(movieFromJson(response.body));
      } else {
        print("BİŞEYLER YANLIŞ MORUK");
      }
    }
    return movies;
  }

  Future<List<Movie>> getWatchList() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var favorites = sharedPreferences.getStringList("list");
    List<Movie> movies = [];
    // print(favorites);
    for (String i in favorites!) {
      final url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$i?api_key=260aea4b58c5eabb859359bb5581fdb7&language=tr");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        movies.add(movieFromJson(response.body));
      } else {
        print("BİŞEYLER YANLIŞ MORUK");
      }
    }
    return movies;
  }
}
