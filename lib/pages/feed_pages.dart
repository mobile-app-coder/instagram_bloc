import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc_cubit/bloc/feed/feed_bloc.dart';

import '../models/member_model.dart';
import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/http_service.dart';
import '../services/utils_service.dart';
import '../views/feed_post_item.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;

  const MyFeedPage({super.key, this.pageController});

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];
  late FeedBloc bloc;

  Future<void> _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });

    var owner = await DBService.getOwner(post.uid);
    sendNotificationToFollowedMember(owner);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(Network.API_SEND_NOTIF, Network.NotifyLike(me, someone));
  }

  _dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Instagram", "Do you want to detele this post?", false);

    if (result) {
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
            /// _apiLoadFeeds(),
          });
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<FeedBloc>(context);
    bloc.add(FeedLoadPostEvent());
    //_apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text("Instagram",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 39,
                    fontFamily: "Billabong")),
            actions: [
              IconButton(
                  onPressed: () {
                    widget.pageController!.animateToPage(2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  icon: Icon(Icons.camera_alt))
            ],
          ),
          body: Stack(
            children: [
              ListView.builder(
                  itemCount: bloc.items.length,
                  itemBuilder: (ctx, index) {
                    return itemPost(context, bloc.items[index]);
                  })
            ],
          ),
        );
      },
    );
  }
}
