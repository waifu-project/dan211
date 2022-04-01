import 'package:dan211/share/dan_movie_card.dart';
import 'package:dan211/share/dan_movie_data.dart';
import 'package:get/get.dart';

class VodCaseController extends GetxController {
  int caseIndex = 0;

  List<DanMovieCardItem> get shareData => danMovieShareConstData.data;

  DanMovieCardItem get currCaseItem => shareData[caseIndex];

  changeCaseIndex(DanMovieCardItem? item) {
    if (item == null) return;
    var _index = shareData.indexOf(item);
    if (_index <= -1) return;
    caseIndex = _index;
    update();
  }

  

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
