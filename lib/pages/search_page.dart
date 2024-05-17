import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/user/user_bloc.dart';
import '../models/member_model.dart';
import '../services/db_service.dart';
import '../services/http_service.dart';
import '../views/item_member.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc bloc;
  bool isLoading = false;
  var searchController = TextEditingController();
  List<Member> items = [];

  void _apiFollowMember(Member someone) async {
    setState(() {
      isLoading = true;
    });
    await DBService.followMember(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DBService.storePostsToMyFeed(someone);

    sendNotificationToFollowedMember(someone);
  }

  void _apiUnFollowMember(Member someone) async {
    setState(() {
      isLoading = true;
    });
    await DBService.unfollowMember(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DBService.removePostsFromMyFeed(someone);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(
        Network.API_SEND_NOTIF, Network.paramsNotify(me, someone));
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SearchBloc>(context);
    bloc.add(const SearchUser(""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "Search",
              style: TextStyle(
                  color: Colors.black, fontSize: 25, fontFamily: "Billabong"),
            ),
          ),
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    //#search member
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7)),
                      child: TextField(
                        controller: bloc.searchController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.grey),
                            icon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey,
                            )),
                        onSubmitted: (text) {
                          bloc.add(SearchUser(text));
                        },
                      ),
                    ),

                    //#member list
                    Expanded(
                        child: ListView.builder(
                      itemCount: bloc.items.length,
                      itemBuilder: (ctx, index) {
                        return BlocProvider(
                          create: (context) => UserBloc(),
                          child: itemOfMember(bloc.items[index]),
                        );
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
