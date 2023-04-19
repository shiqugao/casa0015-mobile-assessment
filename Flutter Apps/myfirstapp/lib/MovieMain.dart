import 'package:flutter/material.dart';
import 'movie.dart';

class MovieFilterPage extends StatefulWidget {
  final List<Movie> movies;

  MovieFilterPage({required this.movies});

  @override
  _MovieFilterPageState createState() => _MovieFilterPageState();
}

class _MovieFilterPageState extends State<MovieFilterPage> {
  List<String> _selectedTypes = [];

  List<Widget> _buildTypeChips() {
    List<Widget> chips = [];

    for (String type in Movie.type) {
      chips.add(
        FilterChip(
          label: Text(type),
          selected: _selectedTypes.contains(type),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTypes.add(type);
              } else {
                _selectedTypes.remove(type);
              }
            });
          },
        ),
      );
    }

    return chips;
  }

  void _applyFilter() {
    List<Movie> filteredMovies = [];

    if (_selectedTypes.isEmpty) {
      filteredMovies = widget.movies;
    } else {
      for (Movie movie in widget.movies) {
        if (_selectedTypes.contains(movie.type)) {
          filteredMovies.add(movie);
        }
      }
    }

    Navigator.pop(context, filteredMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Type',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _buildTypeChips(),
          ),
          SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              child: Text('Apply'),
              onPressed: () => _applyFilter(),
            ),
          ),
        ],
      ),
    );
  }
}