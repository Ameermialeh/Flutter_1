// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/addFavorite.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/Search/SearchCardOffers.dart';
import 'package:gp1_flutter/screens/Search/searchCardPost.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';
import 'package:gp1_flutter/screens/userCard/components/offer_services_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intrinsic_grid_view/intrinsic_grid_view.dart';

class FavoriteBody extends StatefulWidget {
  const FavoriteBody({super.key});

  @override
  State<FavoriteBody> createState() => _FavoriteBodyState();
}

class _FavoriteBodyState extends State<FavoriteBody> {
  late SharedPreferences _sharedPreferences;
  List<PostData> postsList = [];
  List<OffersData> offersList = [];
  List<Favorite> sort = [];
  bool post = false;
  bool offer = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (!post && !offer)
              const Text(
                'Add Posts to your Favorite! ',
                style: TextStyle(fontSize: 25),
              ),
            if (post || offer)
              IntrinsicGridView.vertical(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                verticalSpace: 5,
                children: [
                  for (Favorite favorite in sort)
                    if (favorite.postID != 0) // Display posts
                      SearchCardPost(
                          accountData: postsList.firstWhere(
                              (post) => post.PostID == favorite.postID),
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CardServices(
                                  postData: postsList.firstWhere((post) =>
                                      post.PostID == favorite.postID)),
                            ));
                          })
                    else if (favorite.offerID != 0) // Display offers
                      SearchCardOffers(
                          accountData: offersList.firstWhere(
                              (offer) => offer.offerID == favorite.offerID),
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OfferServices(
                                  offerData: offersList.firstWhere((offer) =>
                                      offer.offerID == favorite.offerID)),
                            ));
                          }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String id = _sharedPreferences.getString('id')!;
    var res = await getFavorite(id);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        if (res['data'][i]['post_id'] != 0) {
          var resPost = await getPostByID(res['data'][i]['post_id']);
          setState(() {
            PostData data = PostData(
                PostID: resPost['post'][0]['post_id'],
                name: resPost['post'][0]['name'],
                Details: resPost['post'][0]['Details'],
                city: resPost['post'][0]['City'],
                mainImg: resPost['post'][0]['mainImg'],
                price: resPost['post'][0]['price'].toDouble(),
                subImg: resPost['post'][0]['subImg'],
                rating: resPost['post'][0]['review'].toDouble());
            postsList.add(data);
            Favorite f = Favorite(
                id: res['data'][i]['id'],
                postID: res['data'][i]['post_id'],
                offerID: res['data'][i]['offer_id']);
            sort.add(f);
            post = true;
          });
        } else {
          var resOffer = await getOfferByID(res['data'][i]['offer_id']);
          setState(() {
            OffersData data = OffersData(
                offerID: resOffer['offer'][0]['offer_id'],
                name: resOffer['offer'][0]['name'],
                city: resOffer['offer'][0]['City'],
                mainImg: resOffer['offer'][0]['mainImg'],
                oldPrice: resOffer['offer'][0]['oldPrice'].toDouble(),
                newPrice: resOffer['offer'][0]['NewPrice'].toDouble(),
                details: resOffer['offer'][0]['Details'],
                fromDate: resOffer['offer'][0]['fromDate'],
                toDate: resOffer['offer'][0]['toDate'],
                subImg: resOffer['offer'][0]['subImg'],
                rating: resOffer['offer'][0]['review'].toDouble());
            offersList.add(data);
            Favorite f = Favorite(
                id: res['data'][i]['id'],
                postID: res['data'][i]['post_id'],
                offerID: res['data'][i]['offer_id']);
            sort.add(f);
            offer = true;
          });
        }
      }
      sort.sort((a, b) => b.id.compareTo(a.id));
    } else {
      print(res['message']);
    }
  }
}
