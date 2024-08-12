import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/cubit/cubit.dart';
import 'package:myapp/cubit/states.dart';
import 'package:myapp/screens/add_tasks_screen.dart';
import 'package:myapp/screens/archieve_screen.dart';
import 'package:myapp/screens/done_screen.dart';
import 'package:myapp/screens/task_screen.dart';
import 'package:myapp/widgets/reusable_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;

  List<Widget> get screens => [
        const TaskScreen(),
        const ArchieveScreen(),
        const DoneScreen(),
      ];

  final ValueNotifier<int> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<String> titles = [
            '${AppCubit.get(context).tasks.length} Tasks',
            '${AppCubit.get(context).archieveTasks.length} Archived',
            '${AppCubit.get(context).doneTasks.length} Done',
          ];
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color.fromARGB(255, 209, 219, 213),
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromARGB(255, 209, 219, 213),
              title: ValueListenableBuilder<int>(
                valueListenable: _valueNotifier,
                builder: (BuildContext context, int index, Widget? child) {
               
                  return Text(titles[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ));
                },
              ),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: screens,
              onPageChanged: (index) {
                _valueNotifier.value = index;
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context)
                        .insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                            status: 'status')
                        .then((value) {
                      setState(() {});
                      Navigator.pop(context);
                      isBottomSheetShown = false;
                    });
                  }
                } else {
                  _scaffoldKey.currentState!
                      .showBottomSheet((BuildContext context) => AddTasksScreen(
                            formKey: formKey,
                            titleController: titleController,
                            timeController: timeController,
                            dateController: dateController,
                          ))
                      .closed
                      .then((value) {
                    isBottomSheetShown = false;
                  });
                  isBottomSheetShown = true;
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
              backgroundColor: Color.fromARGB(255, 108, 209, 138),
            ),
            bottomNavigationBar: AnimatedNotchBottomBar(
                color: Color.fromARGB(255, 94, 187, 170),
                notchBottomBarController: _controller,
                notchColor: Color.fromARGB(255, 108, 209, 138),
                elevation: 1,
                showLabel: true,
                removeMargins: false,
                bottomBarWidth: 500,
                showShadow: false,
                durationInMilliSeconds: 300,
                bottomBarItems: [
                  bottomBarItem(icon: Icons.home, label: 'Home'),
                  bottomBarItem(icon: Icons.archive, label: 'Archive'),
                  bottomBarItem(icon: Icons.check_box, label: 'Done'),
                ],
                onTap: (value) {
                  _pageController.jumpToPage(value);
                },
                kIconSize: 24,
                kBottomRadius: 28),
          );
        },
      ),
    );
  }
}
