// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/search_api.dart';
import 'package:gp1_flutter/models/Bussniss_data.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/ProfileBusinessVeiw/buiness_profile_view.dart';
import 'package:gp1_flutter/screens/Search/SearchCardOffers.dart';
import 'package:gp1_flutter/screens/Search/searchCardPost.dart';
import 'package:gp1_flutter/screens/userCard/Acount_card.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';
import 'package:gp1_flutter/screens/userCard/components/offer_services_user.dart';
import 'city.dart';
import 'search_type.dart';
import 'service_type.dart';
import 'package:intrinsic_grid_view/intrinsic_grid_view.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key, required this.search});
  final String search;
  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  bool account = false;
  bool posts = false;
  bool offers = false;
  List<BusinessData> accountList = [];
  List<PostData> postsList = [];
  List<OffersData> offersList = [];
  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (!account && !posts && !offers)
            if (widget.search.isEmpty)
              const Text(
                'Type Something to search ',
                style: TextStyle(fontSize: 25),
              ),
          if (!account && !posts && !offers)
            if (widget.search.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 120.0 * accountList.length, minHeight: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: accountList.length,
                  itemBuilder: (context, index) {
                    if (widget.search.isEmpty) {
                      return AccountView(
                        accountData: accountList[index],
                        callback: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return HomeProfile(
                                serviceID:
                                    int.parse(accountList[index].serviceId),
                              );
                            },
                          ));
                        },
                      );
                    } else if (accountList[index]
                        .serviceName
                        .toLowerCase()
                        .contains(widget.search)) {
                      return AccountView(
                        accountData: accountList[index],
                        callback: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return HomeProfile(
                                serviceID:
                                    int.parse(accountList[index].serviceId),
                              );
                            },
                          ));
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
          if (!account && !posts && !offers)
            if (widget.search.isNotEmpty)
              IntrinsicGridView.vertical(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                verticalSpace: 5,
                children: [
                  for (PostData post in postsList)
                    if (post.name
                        .toLowerCase()
                        .contains(widget.search.toLowerCase()))
                      SearchCardPost(
                          accountData: post,
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CardServices(postData: post),
                            ));
                          }),
                  for (OffersData offer in offersList)
                    if (offer.name
                        .toLowerCase()
                        .contains(widget.search.toLowerCase()))
                      SearchCardOffers(
                          accountData: offer,
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OfferServices(offerData: offer),
                            ));
                          })
                ],
              ),
          if (account)
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 120.0 * accountList.length, minHeight: 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: accountList.length,
                itemBuilder: (context, index) {
                  if (widget.search.isEmpty) {
                    return AccountView(
                      accountData: accountList[index],
                      callback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return HomeProfile(
                              serviceID:
                                  int.parse(accountList[index].serviceId),
                            );
                          },
                        ));
                      },
                    );
                  } else if (accountList[index]
                      .serviceName
                      .toLowerCase()
                      .contains(widget.search)) {
                    return AccountView(
                      accountData: accountList[index],
                      callback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return HomeProfile(
                              serviceID:
                                  int.parse(accountList[index].serviceId),
                            );
                          },
                        ));
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          if (posts || offers)
            IntrinsicGridView.vertical(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              verticalSpace: 5,
              children: [
                if (posts)
                  for (PostData post in postsList)
                    if (post.name
                        .toLowerCase()
                        .contains(widget.search.toLowerCase()))
                      SearchCardPost(
                          accountData: post,
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CardServices(postData: post),
                            ));
                          }),
                if (offers)
                  for (OffersData offer in offersList)
                    if (offer.name
                        .toLowerCase()
                        .contains(widget.search.toLowerCase()))
                      SearchCardOffers(
                          accountData: offer,
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OfferServices(offerData: offer),
                            ));
                          })
              ],
            ),
        ],
      )),
    );
  }

  void search() async {
    List<String> sType = [];
    List<String> sCity = [];
    double startPrice = price[0].start;
    double endPrice = price[0].end;
    List<SearchType> searchType = SearchType.type;
    List<ServiceType> serviceType = ServiceType.service_type;
    List<City> city = City.city;

    //get Data
    for (int i = 0; i < serviceType.length; i++) {
      if (serviceType[i].isSelected) {
        sType.add(serviceType[i].titleTxt);
      }
    }
    for (int i = 0; i < city.length; i++) {
      if (city[i].isSelected) {
        sCity.add(city[i].titleTxt);
      }
    }

    //search type
    if (searchType[0].isSelected) {
      //account
      if (sType.isNotEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sType.length; i++) {
          for (int j = 0; j < sCity.length; j++) {
            try {
              var res = await accountServiceCity(sType[i], sCity[j]);
              if (res['success']) {
                for (int k = 0; k < res['data'].length; k++) {
                  setState(() {
                    BusinessData data = BusinessData(
                        serviceId: res['data'][k]['id'].toString(),
                        serviceName: res['data'][k]['serviceName'],
                        serviceCity: res['data'][k]['serviceCity'],
                        serviceImg: res['data'][k]['serviceImg'],
                        serviceNum: res['data'][k]['serviceNo'].toString(),
                        serviceType: res['data'][k]['serviceType']);
                    accountList.add(data);
                  });
                }
              } else {
                print(res['message']);
              }
            } catch (e) {
              print('Error: $e');
            }
          }
        }
      } else if (sType.isNotEmpty && sCity.isEmpty) {
        for (int i = 0; i < sType.length; i++) {
          try {
            var res = await accountServiceCity(sType[i], '');
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  BusinessData data = BusinessData(
                      serviceId: res['data'][k]['id'].toString(),
                      serviceName: res['data'][k]['serviceName'],
                      serviceCity: res['data'][k]['serviceCity'],
                      serviceImg: res['data'][k]['serviceImg'],
                      serviceNum: res['data'][k]['serviceNo'].toString(),
                      serviceType: res['data'][k]['serviceType']);
                  accountList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else if (sType.isEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sCity.length; i++) {
          try {
            var res = await accountServiceCity('', sCity[i]);
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  BusinessData data = BusinessData(
                      serviceId: res['data'][k]['id'].toString(),
                      serviceName: res['data'][k]['serviceName'],
                      serviceCity: res['data'][k]['serviceCity'],
                      serviceImg: res['data'][k]['serviceImg'],
                      serviceNum: res['data'][k]['serviceNo'].toString(),
                      serviceType: res['data'][k]['serviceType']);
                  accountList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else {
        var res = await accountServiceCity('', '');
        if (res['success']) {
          for (int k = 0; k < res['data'].length; k++) {
            setState(() {
              BusinessData data = BusinessData(
                  serviceId: res['data'][k]['id'].toString(),
                  serviceName: res['data'][k]['serviceName'],
                  serviceCity: res['data'][k]['serviceCity'],
                  serviceImg: res['data'][k]['serviceImg'],
                  serviceNum: res['data'][k]['serviceNo'].toString(),
                  serviceType: res['data'][k]['serviceType']);
              accountList.add(data);
            });
          }
        } else {
          print(res['message']);
        }
      }
      setState(() {
        account = true;
      });
    }
    if (searchType[1].isSelected) {
      //post
      if (sType.isNotEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sType.length; i++) {
          for (int j = 0; j < sCity.length; j++) {
            try {
              var res = await postServiceCity(
                  sType[i], sCity[j], startPrice, endPrice);
              if (res['success']) {
                for (int k = 0; k < res['data'].length; k++) {
                  setState(() {
                    PostData data = PostData(
                        PostID: res['data'][k]['post_id'],
                        name: res['data'][k]['name'],
                        Details: res['data'][k]['Details'],
                        city: res['data'][k]['City'],
                        mainImg: res['data'][k]['mainImg'],
                        price: res['data'][k]['price'].toDouble(),
                        subImg: res['data'][k]['subImg'],
                        rating: 1);
                    postsList.add(data);
                  });
                }
              } else {
                print(res['message']);
              }
            } catch (e) {
              print('Error: $e');
            }
          }
        }
      } else if (sType.isNotEmpty && sCity.isEmpty) {
        for (int i = 0; i < sType.length; i++) {
          try {
            var res = await postServiceCity(sType[i], '', startPrice, endPrice);
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  PostData data = PostData(
                      PostID: res['data'][k]['post_id'],
                      name: res['data'][k]['name'],
                      Details: res['data'][k]['Details'],
                      city: res['data'][k]['City'],
                      mainImg: res['data'][k]['mainImg'],
                      price: res['data'][k]['price'].toDouble(),
                      subImg: res['data'][k]['subImg'],
                      rating: 1);
                  postsList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else if (sType.isEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sCity.length; i++) {
          try {
            var res = await postServiceCity('', sCity[i], startPrice, endPrice);
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  PostData data = PostData(
                      PostID: res['data'][k]['post_id'],
                      name: res['data'][k]['name'],
                      Details: res['data'][k]['Details'],
                      city: res['data'][k]['City'],
                      mainImg: res['data'][k]['mainImg'],
                      price: res['data'][k]['price'].toDouble(),
                      subImg: res['data'][k]['subImg'],
                      rating: 1);
                  postsList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else {
        var res = await postServiceCity('', '', startPrice, endPrice);
        if (res['success']) {
          for (int k = 0; k < res['data'].length; k++) {
            setState(() {
              PostData data = PostData(
                  PostID: res['data'][k]['post_id'],
                  name: res['data'][k]['name'],
                  Details: res['data'][k]['Details'],
                  city: res['data'][k]['City'],
                  mainImg: res['data'][k]['mainImg'],
                  price: res['data'][k]['price'].toDouble(),
                  subImg: res['data'][k]['subImg'],
                  rating: 1);
              postsList.add(data);
            });
          }
        } else {
          print(res['message']);
        }
      }
      setState(() {
        posts = true;
      });
    }
    if (searchType[2].isSelected) {
      // offer
      if (sType.isNotEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sType.length; i++) {
          for (int j = 0; j < sCity.length; j++) {
            try {
              var res = await offerServiceCity(
                  sType[i], sCity[j], startPrice, endPrice);
              if (res['success']) {
                for (int k = 0; k < res['data'].length; k++) {
                  setState(() {
                    OffersData data = OffersData(
                        offerID: res['data'][k]['offer_id'],
                        name: res['data'][k]['name'],
                        city: res['data'][k]['City'],
                        mainImg: res['data'][k]['mainImg'],
                        oldPrice: res['data'][k]['oldPrice'].toDouble(),
                        newPrice: res['data'][k]['NewPrice'].toDouble(),
                        details: res['data'][k]['Details'],
                        fromDate: res['data'][k]['fromDate'],
                        toDate: res['data'][k]['toDate'],
                        subImg: res['data'][k]['subImg'],
                        rating: 1);
                    offersList.add(data);
                  });
                }
              } else {
                print(res['message']);
              }
            } catch (e) {
              print('Error: $e');
            }
          }
        }
      } else if (sType.isNotEmpty && sCity.isEmpty) {
        for (int i = 0; i < sType.length; i++) {
          try {
            var res =
                await offerServiceCity(sType[i], '', startPrice, endPrice);
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  OffersData data = OffersData(
                      offerID: res['data'][k]['offer_id'],
                      name: res['data'][k]['name'],
                      city: res['data'][k]['City'],
                      mainImg: res['data'][k]['mainImg'],
                      oldPrice: res['data'][k]['oldPrice'].toDouble(),
                      newPrice: res['data'][k]['NewPrice'].toDouble(),
                      details: res['data'][k]['Details'],
                      fromDate: res['data'][k]['fromDate'],
                      toDate: res['data'][k]['toDate'],
                      subImg: res['data'][k]['subImg'],
                      rating: 1);
                  offersList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else if (sType.isEmpty && sCity.isNotEmpty) {
        for (int i = 0; i < sCity.length; i++) {
          try {
            var res =
                await offerServiceCity('', sCity[i], startPrice, endPrice);
            if (res['success']) {
              for (int k = 0; k < res['data'].length; k++) {
                setState(() {
                  OffersData data = OffersData(
                      offerID: res['data'][k]['offer_id'],
                      name: res['data'][k]['name'],
                      city: res['data'][k]['City'],
                      mainImg: res['data'][k]['mainImg'],
                      oldPrice: res['data'][k]['oldPrice'].toDouble(),
                      newPrice: res['data'][k]['NewPrice'].toDouble(),
                      details: res['data'][k]['Details'],
                      fromDate: res['data'][k]['fromDate'],
                      toDate: res['data'][k]['toDate'],
                      subImg: res['data'][k]['subImg'],
                      rating: 1);
                  offersList.add(data);
                });
              }
            } else {
              print(res['message']);
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else {
        var res = await offerServiceCity('', '', startPrice, endPrice);
        if (res['success']) {
          for (int k = 0; k < res['data'].length; k++) {
            setState(() {
              OffersData data = OffersData(
                  offerID: res['data'][k]['offer_id'],
                  name: res['data'][k]['name'],
                  city: res['data'][k]['City'],
                  mainImg: res['data'][k]['mainImg'],
                  oldPrice: res['data'][k]['oldPrice'].toDouble(),
                  newPrice: res['data'][k]['NewPrice'].toDouble(),
                  details: res['data'][k]['Details'],
                  fromDate: res['data'][k]['fromDate'],
                  toDate: res['data'][k]['toDate'],
                  subImg: res['data'][k]['subImg'],
                  rating: 1);
              offersList.add(data);
            });
          }
        } else {
          print(res['message']);
        }
      }
      setState(() {
        offers = true;
      });
    }
    //all
    if (!searchType[0].isSelected &&
        !searchType[1].isSelected &&
        !searchType[2].isSelected) {
      var res = await accountServiceCity('', '');
      if (res['success']) {
        for (int k = 0; k < res['data'].length; k++) {
          setState(() {
            BusinessData data = BusinessData(
                serviceId: res['data'][k]['id'].toString(),
                serviceName: res['data'][k]['serviceName'],
                serviceCity: res['data'][k]['serviceCity'],
                serviceImg: res['data'][k]['serviceImg'],
                serviceNum: res['data'][k]['serviceNo'].toString(),
                serviceType: res['data'][k]['serviceType']);
            accountList.add(data);
          });
        }
      } else {
        print(res['message']);
      }
      //post
      var resPost = await postServiceCity('', '', startPrice, endPrice);
      if (resPost['success']) {
        for (int k = 0; k < resPost['data'].length; k++) {
          setState(() {
            PostData data = PostData(
                PostID: resPost['data'][k]['post_id'],
                name: resPost['data'][k]['name'],
                Details: resPost['data'][k]['Details'],
                city: resPost['data'][k]['City'],
                mainImg: resPost['data'][k]['mainImg'],
                price: resPost['data'][k]['price'].toDouble(),
                subImg: resPost['data'][k]['subImg'],
                rating: 1);
            postsList.add(data);
          });
        }
      } else {
        print(resPost['message']);
      }
      //offer
      var resOffer = await offerServiceCity('', '', startPrice, endPrice);
      if (resOffer['success']) {
        for (int k = 0; k < resOffer['data'].length; k++) {
          setState(() {
            OffersData data = OffersData(
                offerID: resOffer['data'][k]['offer_id'],
                name: resOffer['data'][k]['name'],
                city: resOffer['data'][k]['City'],
                mainImg: resOffer['data'][k]['mainImg'],
                oldPrice: resOffer['data'][k]['oldPrice'].toDouble(),
                newPrice: resOffer['data'][k]['NewPrice'].toDouble(),
                details: resOffer['data'][k]['Details'],
                fromDate: resOffer['data'][k]['fromDate'],
                toDate: resOffer['data'][k]['toDate'],
                subImg: resOffer['data'][k]['subImg'],
                rating: 1);
            offersList.add(data);
          });
        }
      } else {
        print(resOffer['message']);
      }
    }
  }
}
