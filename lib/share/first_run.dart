import 'package:get_storage/get_storage.dart';

class IsFirstRun {
  IsFirstRun._internal();

  final String _firstRunSettingsKey = 'is_first_run';

  final GetStorage _storage = GetStorage();

  Future<void> save(bool flag) async {
    value = flag;
    return _storage.write(_firstRunSettingsKey, flag);
  }

  init() {
    value = _storage.read<bool>(_firstRunSettingsKey) ?? false;
  }

  bool value = false;

  factory IsFirstRun() => _instance;

  static late final IsFirstRun _instance = IsFirstRun._internal();
}

var isFirstRun = IsFirstRun();
