import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/cubit/cubit.dart';

BottomBarItem bottomBarItem({
  required IconData icon,
  required String label,
}) =>
    BottomBarItem(
        inActiveItem: Icon(
          icon,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        activeItem: Icon(
          icon,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        itemLabelWidget: Text(
          label,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ));

Widget defaultFormField(
        {required TextEditingController Controller,
        required String label,
        required IconData icon,
        required GestureTapCallback onTap}) =>
    TextFormField(
      controller: Controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Task';
        }
        return null;
      },
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );

Widget listitem({
  required Map model,
  required VoidCallback archieveClick,
  required VoidCallback deleteClick,
  required VoidCallback doneClick,
}) {
  return ListTile(
    leading: IconButton(
        onPressed: doneClick,
        icon: Icon(
          model['status']=="done"? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.white,
        )),
    title: Row(
      children: [
        Expanded(
          child: Text(
            model['title'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: archieveClick,
            icon: Icon(
              model['status']=="archieve"? Icons.archive : Icons.archive_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 20,
            )),
        IconButton(
            onPressed: deleteClick,
            icon: Icon(
              Icons.delete,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 20,
            )),
      ],
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(left: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model['time'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            model['date'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    ),
  );
}
Widget buildListUi(
  context, {
  required List<Map> tasks,
}) {
  var cubit = AppCubit.get(context);
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .725,
          width: MediaQuery.of(context).size.width * .88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 94, 187, 170),
          ),
          child: ConditionalBuilder(
            condition: tasks.isNotEmpty,
            builder: (BuildContext context) => ListView.separated(
              itemBuilder: (context, index) => listitem(
                  model: tasks[index],
                  archieveClick: () {
                    if(tasks[index]['status'] == 'archieve'){
                      cubit.updateDatabaseState('status', tasks[index]['id']);
                    }else{
                      cubit.updateDatabaseState('archieve', tasks[index]['id']);
                    }
                   
                  },
                  deleteClick: () {
                    cubit.deleteDataFromDatabase(tasks[index]['id']);
                  },
                  doneClick: () {
                   if(tasks[index]['status'] == 'done'){
                      cubit.updateDatabaseState('status', tasks[index]['id']);
                    }else{
                      cubit.updateDatabaseState('done', tasks[index]['id']);
                    }
                  }),
              separatorBuilder: (context, index) => Divider(),
              itemCount: tasks.length),
            fallback: (BuildContext context) => Center(child: Text('There is No Tasks'),
            ),
          ),
        )
      ],
    ),
  );
}
