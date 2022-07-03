import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List albums = ['The Album 1', 'The Album 2', 'The Album 3', 'The Album 4'];

  Future _refresh() async {
    setState(() => albums.clear());
    await Future.delayed(const Duration(seconds: 2));

    final url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List albumsFromApi = json.decode(response.body);
      setState(() {
        albums = albumsFromApi.map<String>((album) {
          final _title = album['title'];
          return _title;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: albums.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    final item = albums[index];
                    return ListTile(
                      title: Text(item),
                    );
                  }),
            ),
    );
  }
}
