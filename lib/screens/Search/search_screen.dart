import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'components/search_body.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.user});
  final bool user;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedService;
  String? selectedCity;
  String searchValue = '';

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: widget.user
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.5],
                    colors: [
                      Color(0xFFE98566),
                      Color(0xFFFD784F),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.5],
                    colors: [
                      Color.fromARGB(255, 200, 192, 208),
                      Color.fromARGB(255, 168, 168, 174),
                    ],
                  ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: TextFormField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: widget.user ? Colors.grey : kPrimaryColor,
                          size: 26,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Search your topic",
                        labelStyle: TextStyle(
                            color: widget.user ? Colors.grey : Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FilterScreen(user: widget.user),
                              fullscreenDialog: true),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.sort,
                            color: widget.user ? Colors.white : Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(child: SearchBody(search: searchValue)),
    );
  }
}
