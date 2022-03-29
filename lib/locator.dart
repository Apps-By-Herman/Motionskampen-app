import 'package:get_it/get_it.dart';
import 'package:moveness/services/api.dart';
import 'package:moveness/services/auth.dart';
import 'package:moveness/services/storage.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerSingleton(StorageService());

  locator.registerSingletonAsync<AuthService>(
    () async {
      final auth = AuthService();
      await auth.loadTokens();
      return auth;
    },
  );
  locator.registerSingletonAsync<ApiService>(
    () async => ApiService(),
    dependsOn: [AuthService],
  );
}
