import 'package:dan211/api/parse_utils.dart';
import 'package:dan211/modules/vod_movie.dart';

class VodCaseRespData {
  VodCaseRespData({
    required this.pageData,
    required this.tags,
    required this.cards,
  });

  final RespPageData pageData;
  final List<String> tags;
  final List<VodCard> cards;
}
