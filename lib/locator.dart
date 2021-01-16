import 'package:get_it/get_it.dart';
import 'package:social_geek/repository/user_repository.dart';
import 'package:social_geek/services/auth/fake_auth_service.dart';
import 'package:social_geek/services/auth/firebase_auth_service.dart';
import 'package:social_geek/services/database/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => FakeAuthServices());
  locator.registerLazySingleton(() => UserRepository());

}