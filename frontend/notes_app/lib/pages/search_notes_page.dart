import 'package:flutter/material.dart';

class SearchNotesPage extends StatefulWidget {
  const SearchNotesPage({super.key});

  @override
  State<SearchNotesPage> createState() => _SearchNotesPageState();
}

class _SearchNotesPageState extends State<SearchNotesPage> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
