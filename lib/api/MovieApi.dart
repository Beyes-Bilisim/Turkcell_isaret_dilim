import 'dart:convert';
import 'package:movie_manager/api/Api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_manager/models/Movie.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieApi {
  Future<List<Movie>> getMovies(String query) async {
    try {
      final url = Uri.parse(
          "${Api.searchMovieUrl}?api_key=${Api.apiKey}&language=${Api.language}&query=" +
              query);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var obj = json.decode(response.body);
        List<Movie> movies =
            (obj["results"] as List).map((e) => Movie.fromJson(e)).toList();
        return movies;
      } else {
        List<Movie> movies = [];
        return movies;
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Movie>> getFavorites() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      List<Movie> movies = [];
      var favorites_offline =
          sharedPreferences.getStringList("favorites_offline");
      for (var i in favorites_offline!) {
        movies.add(movieFromJson(i));
      }
      return movies;
    } else {
      var favorites = sharedPreferences.getStringList("favorites");
      List<Movie> movies = [];
      for (String i in favorites!) {
        final url = Uri.parse(
            "${Api.movieUrl}$i?api_key=${Api.apiKey}&language=${Api.language}");
        final response = await http.get(url);
        if (response.statusCode == 200) {
          movies.add(movieFromJson(response.body));
        } else {
          print("hata");
        }
      }
      return movies;
    }
  }

  Future<List<Movie>> getWatchList() async {
    var connection = await Connectivity().checkConnectivity();
    var sharedPreferences = await SharedPreferences.getInstance();
    if (connection == ConnectivityResult.none) {
      List<Movie> movies = [];
      var list_offline = sharedPreferences.getStringList("list_offline");

      for (var i in list_offline!) {
        movies.add(movieFromJson(i));
      }
      return movies;
    } else {
      var favorites = sharedPreferences.getStringList("list");
      List<Movie> movies = [];
      for (String i in favorites!) {
        final url = Uri.parse(
            "${Api.movieUrl}$i?api_key=${Api.apiKey}&language=${Api.language}");
        final response = await http.get(url);
        if (response.statusCode == 200) {
          movies.add(movieFromJson(response.body));
        } else {
          print("hata");
        }
      }
      return movies;
    }
  }
}
