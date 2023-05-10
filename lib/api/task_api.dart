import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo/core/failure.dart';
import 'package:todo/core/providers.dart';
import 'package:todo/core/type_defs.dart';
import 'package:todo/core/utils.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/user_model.dart';
import '../constants/appwrite_constants.dart';

final taskAPIProvider = Provider((ref) {
  return TaskAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class ITaskAPI {
  FutureEither<Document> addTask(TaskModel task);
  Future<List<Document>> getUserTasks(String uid);
  Stream<RealtimeMessage> getLatestTasks();
  FutureEither<Document> updateCompleted(TaskModel task);
  FutureVoid deleteTask(TaskModel task);
  FutureVoid deleteAll(String uid);
}

class TaskAPI implements ITaskAPI {
  final Databases _db;
  final Realtime _realtime;
  TaskAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> addTask(TaskModel task) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollection,
        documentId: ID.unique(),
        data: task.toMap(),
      );
      return right(document);
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
  Future<List<Document>> getUserTasks(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tasksCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getUsersCompleted(String uid,bool isCompleted) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tasksCollection,
      queries: [
        Query.equal('uid', uid),
        Query.equal('isCompleted', true),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTasks() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tasksCollection}.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> updateCompleted(TaskModel task) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollection,
        documentId: task.id,
        data: {
          'isCompleted': task.isCompleted,
        },
      );
      return right(document);
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
  FutureVoid deleteTask(TaskModel task) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollection,
        documentId: task.id,
      );
    } catch (e, st) {
      print(e.toString());
    }
  }

  
  @override
  FutureVoid deleteAll(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tasksCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );

    for(int i = 0; i<documents.documents.length;i++) {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollection,
        documentId: documents.documents[i].$id,
      );
    }

  }
}
