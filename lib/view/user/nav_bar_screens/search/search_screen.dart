import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/searchServices/search_user_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';

class SearchScreen extends SearchDelegate<String> {
  List<IghoumaneUser> usersList = [];
  final ScrollController _scrollController = ScrollController();
  int limitCount = 1;
  @override
  Widget buildResults(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: width * 0.4,
        height: height * 0.4,
        child: Card(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    IghoumaneUserProvider ighoumaneUserProvider =
        Provider.of<IghoumaneUserProvider>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //log("you reach the end of the scroll");
        ighoumaneUserProvider.updateSearchItemCount();
        //_scrollController.jumpTo(_scrollController.position.pixels /2);
      }
    });
    return FutureBuilder<QuerySnapshot>(
      future: SearchUserServices.searchUsers(query: query, context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: deepBlue,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "User Not Found",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black12,
                    fontSize: width * 0.1),
              ),
            ),
          );
        }

        final result = snapshot.data!.docs;
        return ListView.builder(
          controller: _scrollController,
          itemCount: result.length,
          itemBuilder: (ctx, index) {
            String currentUserId =
                ighoumaneUserProvider.ighoumaneUser.getUserId;
            IghoumaneUser ighoumaneUser = IghoumaneUser.fromMap(
                result[index].data() as Map<String, dynamic>);
            if (ighoumaneUser.getUserId == currentUserId) {
              return Container(
                height: 0,
              );
            }
            return InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Row(
                  children: [
                    Usefulfunctions.blankSpace(width: width * 0.01, height: 0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.7),
                      child: Image(
                        fit: BoxFit.fill,
                        image: const AssetImage("assets/images/youghmane.png"),
                        width: width * 0.155,
                        height: height * 0.07,
                      ),
                    ),
                    Usefulfunctions.blankSpace(width: width * 0.03, height: 0),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ighoumaneUser.getFirstName} ${ighoumaneUser.getLastName}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        Text(
                          Usefulfunctions.getDateFormat(
                              dateFormated: ighoumaneUser.getCreatedDate,
                              context: context),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black26,
                          ),
                        )
                      ],
                    )),
                    StreamBuilder(
                      stream:
                          db.collection("users").doc(currentUserId).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: deepBlue,
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.data()!["freinds"] == null) {
                          //return Text("wrong");
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: TextButton.icon(
                              //key: ValueKey(following),
                              onPressed: () {
                                log("add freind ${ighoumaneUser.getUserId}");
                                SearchUserServices.addNewFreind(
                                    freindId: ighoumaneUser.getUserId,
                                    context: context);
                                //following = !following;
                              },
                              icon: const Icon(
                                Icons.person_add,
                                color: white,
                              ),
                              label: const Text(
                                "Follow",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    deepBlueDark),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          );
                        }
                        var freids = snapshot.data!.data()!["freinds"];
                        if (freids.contains(ighoumaneUser.getUserId)) {
                          //return Text("already freind");
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: TextButton.icon(
                              //key: ValueKey(following),
                              onPressed: () {
                                SearchUserServices.deleteFreind(
                                    context: context,
                                    freindId: ighoumaneUser.getUserId);
                              },
                              icon: const Icon(
                                Icons.check,
                                color: white,
                              ),
                              label: const Text(
                                "Following",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    deepBlueDark),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          );
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: TextButton.icon(
                            //key: ValueKey(following),
                            onPressed: () {
                              SearchUserServices.addNewFreind(
                                  freindId: ighoumaneUser.getUserId,
                                  context: context);
                            },
                            icon: const Icon(
                              Icons.person_add,
                              color: white,
                            ),
                            label: const Text(
                              "Follow",
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(deepBlueDark),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                        );
                      },
                    ),
                    Usefulfunctions.blankSpace(width: width * 0.01, height: 0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }
}
