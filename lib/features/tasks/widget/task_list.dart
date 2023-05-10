import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/common.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/tasks/controller/task_controller.dart';
import 'package:todo/features/tasks/widget/task_card.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/user_model.dart';

import '../../../constants/appwrite_constants.dart';

class TaskList extends ConsumerWidget {
  final bool isCompleted;
  const TaskList({required this.isCompleted,super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserAccountProvider).value!.$id;
    return ref.watch(getTaskByUserIdProvider(userId)).when(
          data: (tweets) {
            return ref.watch(getLatestTasksProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tasksCollection}.documents.*.create',
                    )) {
                      if (data.payload['uid'] == userId) {
                        tweets.add(TaskModel.fromMap(data.payload));
                      }
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tasksCollection}.documents.*.update',
                    )) {
                      // get id of original tweet
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final tweetId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;

                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((element) => element.id == tweetId);

                      tweet = TaskModel.fromMap(data.payload);
                      if (data.payload['uid'] == userId) {
                        tweets.insert(tweetIndex, tweet);
                      }
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tasksCollection}.documents.*.delete',
                    )) {
                      tweets.remove(TaskModel.fromMap(data.payload));
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (tweets[index].isCompleted == isCompleted) {
                          final tweet = tweets[index];
                          return TaskCard(task: tweet);
                        }
                        else {
                          return Container();
                        }
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (tweets[index].isCompleted == isCompleted) {
                          final tweet = tweets[index];
                          return TaskCard(task: tweet);
                        }
                        else {
                          return Container();
                        }
                      },
                    );
                  },
                );
            // return ListView.builder(
            //   itemCount: tweets.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     final tweet = tweets[index];
            //     return TweetCard(tweet: tweet);
            //   },
            // );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
