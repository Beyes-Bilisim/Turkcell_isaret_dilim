import 'package:flutter/material.dart';
import 'package:movie_manager/models/Movie.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({Key? key}) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // color: Colors.grey[800],
      child: InkWell(
        child: ListTile(
          leading: FlutterLogo(
            size: 40,
          ),
          title: Text("Kaptan America",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(""),
          ]),
        ),
        onTap: () {
          // Navigator.of(context)
          // .push(MaterialPageRoute(builder: (context) => Details(title: widget.title,content: widget.content,language: widget.language)));
        },
      ),
    );
  }
}
