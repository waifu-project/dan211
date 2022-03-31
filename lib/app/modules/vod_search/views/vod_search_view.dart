import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
import 'package:dan211/app/modules/vod_search/views/w_vod_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vod_search_controller.dart';

class VodSearchView extends StatelessWidget {
  const VodSearchView({Key? key}) : super(key: key);

  String get _placeholder => "搜索";

  String get _img =>
      'https://pic.laoyapic.com/upload/vod/20220331-1/c09faee339f0bed74db4cb04b3de3d96.jpg';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSearchTextField(
          placeholder: _placeholder,
        ),
        // trailing: CupertinoButton(
        //   padding: EdgeInsets.symmetric(vertical: 4,),
        //   onPressed: () {
        //     /// TODO
        //   },
        //   child: Text("取消"),
        // ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CupertinoPageBar(),
            Expanded(
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      42,
                      (index) => VodCardWidget(
                        space: 12.0,
                        imageURL: _img,
                        onTap: () {},
                        title: _placeholder,
                      ),
                    ).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
