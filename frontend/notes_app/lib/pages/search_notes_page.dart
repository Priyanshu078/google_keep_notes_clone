import 'package:flutter/material.dart';
import 'package:notes_app/constants/colors.dart';

class SearchNotesPage extends StatefulWidget {
  const SearchNotesPage({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<SearchNotesPage> createState() => _SearchNotesPageState();
}

class _SearchNotesPageState extends State<SearchNotesPage> {
  final FocusNode focusNode = FocusNode();
  SearchController searchController = SearchController();

  @override
  void initState() {
    // focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SearchViewTheme(
        data: const SearchViewThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: SearchAnchor(
            isFullScreen: true,
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                leading: const Icon(Icons.search),
                focusNode: focusNode,
                shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                controller: controller,
                onTap: () {
                  controller.openView();
                },
              );
            },
            viewBuilder: (suggestions) {
              return Container(
                height: widget.height,
                width: widget.width,
                color: textFieldBackgoundColor,
                child: const Center(
                    child: Icon(
                  Icons.mood,
                  color: Colors.black,
                )),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return <Widget>[const Icon(Icons.abc)];
            }),
      ),
    );
  }
}
