import 'package:get_it/get_it.dart';
import 'package:social_geek/repository/user_repository.dart';
import 'package:social_geek/services/auth/fake_auth_service.dart';
import 'package:social_geek/services/auth/firebase_auth_service.dart';
import 'package:social_geek/services/database/firestore_db_service.dart';
import 'package:social_geek/services/notification/notification_service.dart';
import 'package:social_geek/services/storage/firebase_storage_service.dart';
import 'package:social_geek/view_models/search_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthServices());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => NotificationService());

  locator.registerFactory(() => SearchViewModel());
}