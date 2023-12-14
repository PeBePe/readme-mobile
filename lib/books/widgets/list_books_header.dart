import 'package:flutter/material.dart';

class ListBooksHeader extends StatefulWidget {
  const ListBooksHeader({Key? key}) : super(key: key);

  @override
  State<ListBooksHeader> createState() => _ListBooksHeaderState();
}

class _ListBooksHeaderState extends State<ListBooksHeader> {
  String selectedSearchCriteria = 'judul'; // Default search criteria
  String selectedCategory = 'Semua Kategori'; // Default search criteria

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/list_books_header.jpg'), // Replace with your image asset path
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Adjust opacity as needed
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Temukan banyak buku menarik disini!",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8.0),
          Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black), // Set text color
                decoration: InputDecoration(
                  filled: true, // Add this line
                  fillColor: Colors.white, // Set the background color
                  hintText: "Cari buku...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Remove border
                    borderRadius: BorderRadius.circular(100),
                  ),
                  contentPadding: EdgeInsets.symmetric(),
                ),
              ),
              SizedBox(width: 8.0),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color
                    ),
                    child: DropdownButton<String>(
                      value: selectedSearchCriteria,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedSearchCriteria = newValue;
                          });
                        }
                      },
                      items: <String>['judul', 'penulis', 'penerbit']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                      items: <String>['Semua Kategori', 'Kategori 1']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
