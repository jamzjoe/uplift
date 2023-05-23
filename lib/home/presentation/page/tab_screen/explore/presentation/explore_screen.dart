import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'package:uplift/utils/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  int paginationLimit = 10;
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    tabController = TabController(length: 12, vsync: this);
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        extendBody: true,
        body: RefreshIndicator(
          onRefresh: () async => searchQueryConditions(pageIndex, context),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: DefaultTabController(
              initialIndex: 0,
              length: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: whiteColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const DefaultText(
                                text: 'Embrace the journey of',
                                color: darkColor,
                              ),
                              const HeaderText(
                                text: 'spiritual discovery with us.',
                                color: secondaryColor,
                                size: 21,
                              ),
                              defaultSpace,
                              MySearchBar(
                                onSubmit: (p0) async {
                                  BlocProvider.of<ExploreBloc>(context)
                                      .add(SearchPrayerRequest(p0.trim()));
                                  tabController.animateTo(11);
                                },
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          controller: tabController,
                          onTap: (value) {
                            setState(() {
                              pageIndex = value + 1;
                            });
                            int index = value + 1;
                            searchQueryConditions(index, context);
                          },
                          isScrollable: true,
                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'Popular'),
                            Tab(text: 'Personal'),
                            Tab(text: 'Family'),
                            Tab(text: 'Community'),
                            Tab(text: 'Global'),
                            Tab(text: 'Gratitude'),
                            Tab(text: 'Healing'),
                            Tab(text: 'Faith'),
                            Tab(text: 'Vocational'),
                            Tab(text: 'Special'),
                            Tab(text: 'Result'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if (state is LoadingPrayerRequesListSuccess) {
                        if (state.prayerRequestPostModel.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: NoDataMessage(
                                  text: 'No prayer intention found.',
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  150),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            ...state.prayerRequestPostModel.map((e) => PostItem(
                                  postModel: e,
                                  user: e.userModel,
                                  fullView: false,
                                )),
                          ],
                        );
                      }
                      return const PostShimmerLoading();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void searchQueryConditions(int index, BuildContext context) {
    if (index == 1) {
      getAll(context);
    } else if (index == 2) {
      getAllPopular(context);
    } else if (index >= 3 && index <= 10) {
      String query = [
        'personal',
        'family',
        'community',
        'global',
        'gratitude',
        'faith',
        'vocational',
        'special'
      ][index - 3];
      getAllWithQuery(context, query);
    }
  }

  void getAllWithQuery(BuildContext context, String query) {
    BlocProvider.of<ExploreBloc>(context).add(SearchPrayerRequest(query));
  }

  void getAllPopular(BuildContext context) {
    BlocProvider.of<ExploreBloc>(context).add(GetPrayerRequestByPopularity());
  }

  void getAll(BuildContext context) {
    BlocProvider.of<ExploreBloc>(context)
        .add(const GetExplorePrayerRequestList());
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reached the end of the scroll view
      // Perform your desired action here, such as fetching more data
      loadMoreData();
    }
  }

  void loadMoreData() async {
    setState(() {
      paginationLimit = paginationLimit + 10;
    });
    BlocProvider.of<ExploreBloc>(context)
        .add(GetExplorePrayerRequestList(limit: paginationLimit));
  }
}
