import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/config/app_config.dart';

part 'app_config_provider.g.dart';

@riverpod
Future<AppConfig> appConfig(AppConfigRef ref) async {
  return AppConfig.initialize();
}
