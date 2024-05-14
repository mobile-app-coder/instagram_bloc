import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/feed/feed_bloc.dart';
import '../bloc/home/home_cubit.dart';
import '../pages/feed_pages.dart';
import '../pages/likes_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';
import '../pages/upload_page.dart';

Widget home_view(PageController pageController, HomeCubit cubit) {
  return PageView(
    controller: pageController,
    onPageChanged: (index) {
      cubit.onPageChange(index);
    },
    children: [
      BlocProvider(
        create: (context) => FeedBloc(),
        child: MyFeedPage(
          pageController: cubit.pageController,
        ),
      ),
      SearchPage(),
      UploadPage(
        pageController: cubit.pageController,
      ),
      LikesPage(),
      ProfilePage()
    ],
  );
}

Widget viewOfHome(HomeCubit cubit) {
  return Scaffold(
    body: PageView(
      controller: cubit.pageController,
      onPageChanged: (index) {
        cubit.onPageChange(index);
      },
      children: [
        BlocProvider(
          create: (context) => FeedBloc(),
          child: MyFeedPage(
            pageController: cubit.pageController,
          ),
        ),
        SearchPage(),
        UploadPage(
          pageController: cubit.pageController,
        ),
        LikesPage(),
        ProfilePage()
      ],
    ),
    bottomNavigationBar: CupertinoTabBar(
      currentIndex: cubit.currentPage,
      onTap: (index) {
        cubit.onTabChanged(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 32,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 32,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box,
            size: 32,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            size: 32,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            size: 32,
          ),
        )
      ],
    ),
  );
}
