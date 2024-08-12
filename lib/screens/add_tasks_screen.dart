import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/widgets/reusable_widgets.dart';

class AddTasksScreen extends StatelessWidget {
  const AddTasksScreen({super.key,required this.formKey,required this.titleController,required this.timeController,required this.dateController });
  final GlobalKey<FormState> formKey ;
  final TextEditingController titleController  ;
  final TextEditingController timeController  ;
  final TextEditingController dateController  ;
  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            Controller: titleController,
                            label: 'Enter Your Task',
                            icon: Icons.title,
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            Controller: timeController,
                            label: 'Enter Task Time',
                            icon: Icons.timer_rounded,
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text = value!.format(context);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            Controller: dateController,
                            label: 'Enter Task Date',
                            icon: Icons.date_range,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: DateTime.now(),
                                lastDate: DateTime.parse('3050-05-09'),
                              ).then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
  }
}