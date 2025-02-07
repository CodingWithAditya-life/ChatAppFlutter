import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar(
      {super.key, required this.searchController, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF292F3F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: searchController,
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade500,
            ),
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
