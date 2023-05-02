import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import 'post_item.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
      builder: (context, state) {
        if (state is LoadingPrayerRequesListSuccess) {
          if (state.prayerRequestPostModel.isEmpty) {
            return const Center(child: EndOfPostWidget());
          }
          return ListView(
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              ...state.prayerRequestPostModel.map((e) => PostItem(
                    postModel: e,
                  )),
              defaultSpace,
              const EndOfPostWidget()
            ],
          );
        }
        return const PostShimmerLoading();
      },
    );
  }
}

class EndOfPostWidget extends StatelessWidget {
  const EndOfPostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Image(
            image: AssetImage('assets/angel.png'),
            width: 70,
            height: 70,
          ),
          defaultSpace,
          DefaultText(
              textAlign: TextAlign.center,
              text: "Keep spreading joy and positivity\nwherever you go!",
              color: secondaryColor),
        ],
      ),
    );
  }
}
