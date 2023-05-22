import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 12, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: 0,
          length: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultText(
                        text: 'Embrace the journey of', color: secondaryColor),
                    const HeaderText(
                        text: 'spiritual discovery with us.',
                        color: secondaryColor,
                        size: 21),
                    defaultSpace,
                    MySearchBar(
                      onSubmit: (p0) async {
                        BlocProvider.of<GetPrayerRequestBloc>(context)
                            .add(SearchPrayerRequest(p0.trim()));
                        tabController!.animateTo(11);
                      },
                    ),
                  ],
                ),
              ),
              TabBar(
                  controller: tabController,
                  onTap: (value) {
                    setState(() {
                      pageIndex + 1;
                    });
                    int index = value + 1;
                    searchQueryConditions(index, context);
                  },
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      text: 'All',
                    ),
                    Tab(
                      text: 'Popular',
                    ),
                    Tab(
                      text: 'Personal',
                    ),
                    Tab(
                      text: 'Family',
                    ),
                    Tab(
                      text: 'Community',
                    ),
                    Tab(
                      text: 'Global',
                    ),
                    Tab(
                      text: 'Gratitude',
                    ),
                    Tab(
                      text: 'Healing',
                    ),
                    Tab(
                      text: 'Faith',
                    ),
                    Tab(
                      text: 'Vocational',
                    ),
                    Tab(
                      text: 'Special',
                    ),
                    Tab(
                      text: 'Result',
                    )
                  ]),
              Expanded(child:
                  BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
                builder: (context, state) {
                  if (state is LoadingPrayerRequesListSuccess) {
                    if (state.prayerRequestPostModel.isEmpty) {
                      return const Center(
                        child: DefaultText(
                            text: 'Prayer request not found',
                            color: secondaryColor),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        searchQueryConditions(pageIndex, context);
                      },
                      child: ListView(
                        children: [
                          ...state.prayerRequestPostModel.map((e) => PostItem(
                                postModel: e,
                                user: e.userModel,
                                fullView: false,
                              ))
                        ],
                      ),
                    );
                  }
                  return const PostShimmerLoading();
                },
              ))
            ],
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
    } else if (index == 3) {
      getAllWithQuery(context, 'personal');
    } else if (index == 4) {
      getAllWithQuery(context, 'family');
    } else if (index == 5) {
      getAllWithQuery(context, 'community');
    } else if (index == 6) {
      getAllWithQuery(context, 'global');
    } else if (index == 7) {
      getAllWithQuery(context, 'gratitude');
    } else if (index == 8) {
      getAllWithQuery(context, 'faith');
    } else if (index == 9) {
      getAllWithQuery(context, 'vocational');
    } else if (index == 10) {
      getAllWithQuery(context, 'special');
    }
  }

  void getAllWithQuery(BuildContext context, String query) {
    BlocProvider.of<GetPrayerRequestBloc>(context)
        .add(SearchPrayerRequest(query));
  }

  void getAllPopular(BuildContext context) {
    BlocProvider.of<GetPrayerRequestBloc>(context)
        .add(GetPrayerRequestByPopularity());
  }

  void getAll(BuildContext context) {
    BlocProvider.of<GetPrayerRequestBloc>(context)
        .add(const GetPostRequestList());
  }
}
