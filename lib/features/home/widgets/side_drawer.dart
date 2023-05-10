import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/common.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/tasks/controller/task_controller.dart';
import 'package:todo/theme/theme.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                size: 30,
              ),
              title: const Text(
                'delete all',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref
                          .read(taskControllerProvider.notifier)
                          .deleteAll(currentUser.uid, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}