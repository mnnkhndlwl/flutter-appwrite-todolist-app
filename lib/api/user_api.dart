import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo/constants/appwrite_constants.dart';
import 'package:todo/core/failure.dart';
import 'package:todo/core/providers.dart';
import 'package:todo/core/type_defs.dart';
import 'package:todo/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(
        appwriteDatabaseProvider),
        realtime: ref.watch(appwriteRealtimeProvider),
         //the UserAPI instance is created with a db property that is obtained from the appwriteDatabaseProvider. This is done using the ref.watch method, which watches a provider and retrieves its current value.
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({required Databases db,required Realtime realtime}) : _db = db , _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

}