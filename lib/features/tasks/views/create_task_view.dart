import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/common.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/tasks/controller/task_controller.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
  const CreateTweetScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String _priority = 'High';

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTasktodb() {
    ref.read(taskControllerProvider.notifier).addTask(
          title: titleController.text,
          description: descriptionController.text,
          priority: _priority,
          context: context,
        );
  }
//The ref.read method is used to obtain a ProviderContainer
//from the BuildContext of the widget. This container is used to read the tweetControllerProvider provider and obtain its value.

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(taskControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your details of your task'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // to close the current page
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButton(
                        // Initial Value
                        value: _priority,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: _priorities.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            _priority = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: addTasktodb,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
