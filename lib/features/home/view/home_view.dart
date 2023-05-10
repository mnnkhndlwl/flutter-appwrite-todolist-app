import 'package:flutter/material.dart';
import 'package:todo/constants/constants.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/home/widgets/side_drawer.dart';
import 'package:todo/features/tasks/views/create_task_view.dart';
import 'package:todo/features/tasks/widget/task_list.dart';
import '../../../theme/theme.dart';

enum TaskFilter {
  Completed,
  Incompleted,
}

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final appBar = UIConstants.appBar();
  TaskFilter _taskFilter = TaskFilter.Incompleted;

  void _onFilterSelected(TaskFilter filter) {
    setState(() {
      _taskFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _onFilterSelected(TaskFilter.Incompleted),
                style: ElevatedButton.styleFrom(
                  primary: _taskFilter == TaskFilter.Incompleted
                      ? Pallete.blueColor
                      : Colors.grey,
                ),
                child: Text('Incompleted'),
              ),
              ElevatedButton(
                onPressed: () => _onFilterSelected(TaskFilter.Completed),
                style: ElevatedButton.styleFrom(
                  primary: _taskFilter == TaskFilter.Completed
                      ? Pallete.blueColor
                      : Colors.grey,
                ),
                child: Text('Completed'),
              ),
            ],
          ),
          Expanded(
            child: _taskFilter == TaskFilter.Completed
                    ? const TaskList(isCompleted : true)
                    : const TaskList(isCompleted : false),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreateTweetScreen.route());
        },
        focusColor: Pallete.redColor,
        hoverColor: Pallete.backgroundColor,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}
