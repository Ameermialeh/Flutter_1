import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/recommendation/postsView.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

class viewPackages extends StatefulWidget {
  final Map<String, dynamic> listOfData;
  final Map<String, bool> listOfSwitches;
  final double Budget;

  viewPackages({
    Key? key,
    required this.listOfData,
    required this.listOfSwitches,
    required this.Budget,
  }) : super(key: key);

  @override
  State<viewPackages> createState() => _viewPackagesState();
}

class _viewPackagesState extends State<viewPackages> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> allWidgets = [
      getBestRate(),
      getBestPrice(),
      getRandom(),
      getRandom(),
    ];

    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        child: AppBarAll(appBarName: 'Package'),
        preferredSize: Size.fromHeight(100),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: ((allWidgets.length) / 4).ceil(),
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * 4;
                int endIndex = (pageIndex + 1) * 4;
                if (endIndex > allWidgets.length) {
                  endIndex = allWidgets.length;
                }
                List<Widget> currentPageWidgets =
                    allWidgets.sublist(startIndex, endIndex);
                return buildPage(currentPageWidgets);
              },
            ),
          ),
          buildPageIndicator(((allWidgets.length / 4).ceil()).toInt()),
        ],
      ),
    );
  }

  Widget buildPage(List<Widget> widgets) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget buildCategoryWidget(String category, dynamic bestPost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          width: 50,
          child:
              Image.network('${Utils.baseUrl}/mainImg/${bestPost['mainImg']}'),
        ),
        const Divider(color: Color(0xFFDBDADA)),
      ],
    );
  }

  Widget getBestPrice() {
    List<Widget> bestPriceWidgets = [];
    List<dynamic> bestPosts = [];
    List<String> noDataString = [];
    [
      'DJ_OR_Signer',
      'photo',
      'Decorating',
      'Chair_rental',
      'Stage_rental',
      'Restaurant',
      'Organizer'
    ].forEach((category) {
      if (widget.listOfData['data']['data'][category] != null) {
        List<dynamic> posts = widget.listOfData['data']['data'][category];
        if (posts.isNotEmpty) {
          var bestPost =
              posts.reduce((a, b) => (a['price']) < (b['price']) ? a : b);
          bestPosts.add(bestPost);
          bestPriceWidgets.add(buildCategoryWidget(category, bestPost));
        } else {
          widget.listOfSwitches.forEach((key, value) {
            if (key == category && value == true && posts.isEmpty) {
              noDataString.add(category);
            }
          });
        }
      }
    });
    var rate = 0.0;
    bestPosts.forEach((element) {
      rate += (element['review'] as num).toDouble() / bestPosts.length;
    });
    var price = 0.0;
    bestPosts.forEach((element) {
      price += element["price"];
    });
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return postsView(
              title: 'Best Price',
              postData: bestPosts,
            );
          },
        ));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
                BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.2))),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 7),
                child: Text(
                  'Best Price',
                  style: TextStyle(fontSize: 25, color: kPrimaryColor),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bestPriceWidgets,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (noDataString.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Their is no Data for ${noDataString}'),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      'Rate: ${rate.toStringAsFixed(1)} ',
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .2,
                        bottom: 10),
                    child: Center(
                      child: Text(
                        '\$${widget.Budget.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5, bottom: 10),
                    child: Text(
                      '\$ $price',
                      style: TextStyle(fontSize: 17, color: kPrimaryColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRandom() {
    List<Widget> bestPriceWidgets = [];
    List<dynamic> bestPosts = [];
    List<String> noDataString = [];

    Random random = Random();

    [
      'DJ_OR_Signer',
      'photo',
      'Decorating',
      'Chair_rental',
      'Stage_rental',
      'Restaurant',
      'Organizer'
    ].forEach((category) {
      if (widget.listOfData['data']['data'][category] != null) {
        List<dynamic> posts = widget.listOfData['data']['data'][category];
        if (posts.isNotEmpty) {
          var randomPostIndex = random.nextInt(posts.length);
          var bestPost = posts[randomPostIndex];

          bestPosts.add(bestPost);
          bestPriceWidgets.add(buildCategoryWidget(category, bestPost));
        } else {
          widget.listOfSwitches.forEach((key, value) {
            if (key == category && value == true && posts.isEmpty) {
              noDataString.add(category);
            }
          });
        }
      }
    });

    var rate = 0.0;
    bestPosts.forEach((element) {
      rate += (element['review'] as num).toDouble() / bestPosts.length;
    });

    var price = 0.0;
    bestPosts.forEach((element) {
      price += element["price"];
    });

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return postsView(
              title: 'Other',
              postData: bestPosts,
            );
          },
        ));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width - 30,
          // height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
                BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.2))),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 7),
                child: Text(
                  'Other suggestion',
                  style: TextStyle(fontSize: 25, color: kPrimaryColor),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bestPriceWidgets,
                ),
              ),
              SizedBox(height: 10),
              if (noDataString.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Their is no Data for ${noDataString}'),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      'Rate: ${rate.toStringAsFixed(1)} ',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5, bottom: 10),
                    child: Text(
                      'Price: \$ $price ',
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBestRate() {
    List<Widget> bestRatedWidgets = [];
    List<dynamic> bestPosts = [];

    List<String> noDataString = [];
    [
      'DJ_OR_Signer',
      'photo',
      'Decorating',
      'Chair_rental',
      'Stage_rental',
      'Restaurant',
      'Organizer'
    ].forEach((category) {
      if (widget.listOfData['data']['data'][category] != null) {
        List<dynamic> posts = widget.listOfData['data']['data'][category];
        if (posts.isNotEmpty) {
          var bestPost =
              posts.reduce((a, b) => (a['review']) > (b['review']) ? a : b);
          bestPosts.add(bestPost);
          bestRatedWidgets.add(buildCategoryWidget(category, bestPost));
        } else {
          widget.listOfSwitches.forEach((key, value) {
            if (key == category && value == true && posts.isEmpty) {
              noDataString.add(category);
            }
          });
        }
      }
    });
    var rate = 0.0;
    bestPosts.forEach((element) {
      rate += (element['review'] as num).toDouble() / bestPosts.length;
    });
    var price = 0.0;
    bestPosts.forEach((element) {
      price += element["price"];
    });

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return postsView(
              title: 'Best Rate',
              postData: bestPosts,
            );
          },
        ));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width - 30,
          // height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
                BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.2))),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 7),
                child: Text(
                  'Best Rate',
                  style: TextStyle(fontSize: 25, color: kPrimaryColor),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: bestRatedWidgets,
                ),
              ),
              SizedBox(height: 10),
              if (noDataString.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Their is no Data for ${noDataString}'),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      'Rate: ${rate.toStringAsFixed(1)} ',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5, bottom: 10),
                    child: Text(
                      'Price: \$ $price ',
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageIndicator(int pageCount) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pageCount,
          (index) => Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? kPrimaryColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
