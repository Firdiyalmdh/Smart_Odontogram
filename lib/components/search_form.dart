import 'package:flutter/material.dart';
import 'package:odontogram/components/pasien_provider.dart';
import 'package:provider/provider.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    Key? key,
    required TextEditingController searchController,
  })  : _searchController = searchController,
        super(key: key);

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 400,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          Provider.of<PasienProvider>(context, listen: false)
              .searchPasien(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none, // Remove the outline
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none, // Remove the outline when focused
          ),
        ),
      ),
    );
  }
}
