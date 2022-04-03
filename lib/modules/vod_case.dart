import 'package:dan211/api/parse_utils.dart';
import 'package:dan211/modules/vod_movie.dart';

class VodCaseRespData {
  VodCaseRespData({
    required this.pageData,
    required this.tags,
    required this.cards,
  });

  RespPageData pageData;
  List<String> tags;
  List<VodCard> cards;
}
