import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/services/firebase_services/searchServices/search_user_services.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';

class SearchScreen extends SearchDelegate<String> {
  List<IghoumaneUser> usersList = [];
  bool loading = false;
  //searching();
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
    return FutureBuilder<QuerySnapshot>(
      future: SearchUserServices.searchUsers(query: query),
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

        //List<IghoumaneUser> lstUsers = snapshot.data!.docs
        //    .map((el) => IghoumaneUser.getUserFromQuerySnapshot(el))
        //    .toList()
        //    .where((el) {
        //  //return  query.contains(el.getFirstName)  || query.contains(el.getLastName);
        //  //el.getFirstName.contains(query);
        //  return el.getFirstName.contains(query) ||
        //      el.getLastName.contains(query);
        //}).toList();
        final result = snapshot.data!.docs;
        return ListView.builder(
            itemCount: result.length,
            itemBuilder: (ctx, index) {
              IghoumaneUser ighoumaneUser = IghoumaneUser.fromMap(
                  result[index].data() as Map<String, dynamic>);
              //IghoumaneUser ighoumaneUser = usersList[index];
              return InkWell(
                onTap: () {
                  showResults(context);
                  //showSuggestions(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  child: Row(
                    children: [
                      Usefulfunctions.blankSpace(
                          width: width * 0.01, height: 0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.7),
                        child: Image(
                          fit: BoxFit.fill,
                          image:
                              const AssetImage("assets/images/youghmane.png"),
                          width: width * 0.155,
                          height: height * 0.07,
                        ),
                      ),
                      Usefulfunctions.blankSpace(
                          width: width * 0.03, height: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${ighoumaneUser.getFirstName} ${ighoumaneUser.getLastName}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                          const Text(
                            "12-10-2024",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black26,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
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
          icon: Icon(Icons.clear))
    ];
  }
}
