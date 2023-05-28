import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/explore_post_list_view.dart';
import 'package:uplift/utils/widgets/default_loading.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, state) {
            if (state is LoadingPrayerRequesListSuccess) {
              return PostListView(
                postList: state.prayerRequestPostModel,
              );
            } else {
              return const Center(
                child: DefaultLoading(),
              );
            }
          },
        ),
      ),
    );
  }
}
