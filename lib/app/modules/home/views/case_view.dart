import 'package:dan211/share/dan_movie_card.dart';
import 'package:dan211/share/dan_movie_data.dart';
import 'package:dan211/widget/k_list_tile.dart';
import 'package:flutter/cupertino.dart';

class DoMovieCaseView extends StatelessWidget {
  const DoMovieCaseView({Key? key}) : super(key: key);

  String get _title => "选择线路";

  List<DanMovieCardItem> get _data => danMovieShareConstData.data;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "返回",
        middle: Text(_title),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            /// TODO impl this
          },
          child: const Icon(
            CupertinoIcons.zzz,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  _data.length,
                  (index) => CupertinoListTile(
                    // selected: index % 2 == 0,
                    trailing: const SizedBox.shrink(),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(CupertinoIcons.videocam_circle,),
                    title: Text(
                      _data[index].text ?? "",
                    ),
                    onTap: () {
                      //
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
