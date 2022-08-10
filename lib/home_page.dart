import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/add_task.dart';
import 'package:todoapp/colors.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          buildAppBar(
              context,
              IconButton(
                onPressed: () {
                  provider.changeMode();
                },
                icon: Icon(
                  provider.isDark
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_round_outlined,
                  size: 24,
                  color: provider.isDark ? Colors.white : darkGreyClr,
                ),
              )),
          addTaskBar(context),
          addDataBar(context),
          const SizedBox(
            height: 10,
          ),
          showTasks(context),
        ],
      ),
    );
  }

  addTaskBar(context) {
    var provider = Provider.of<MyProvider>(context);
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 10,
        top: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subheadingStyle.copyWith(
                  color: provider.isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Today",
                style: headingStyle.copyWith(
                  color: provider.isDark ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
          Button(
            onTap: () {
              navigatorTo(context, const AddTaskPage());
            },
            width: 100.0,
            label: '+ Add Task',
          )
        ],
      ),
    );
  }

  addDataBar(context) {
    var provider = Provider.of<MyProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        selectedTextColor: Colors.white,
        initialSelectedDate: provider.selectedDate,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (newDate) {
          provider.changeSelectedDate(newDate);
        },
      ),
    );
  }

  showTasks(context) {
    var provider = Provider.of<MyProvider>(context);
    return Expanded(
      child: provider.tasks.isNotEmpty
          ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.tasks.length,
        itemBuilder: (ctx, index) {
          return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 1000),
              position: index,
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () =>
                        showBottomSheets(context,index)
                    ,
                    child: taskTile(index, context),
                  ),
                ),
              ));
        },
      )
          : noTask(context),
    );
  }

  noTask(context) {
    var provider = Provider.of<MyProvider>(context);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                const SizedBox(
                  height: 100,
                ),
                SvgPicture.asset(
                  'assets/task.svg',
                  height: 150,
                  semanticsLabel: 'Task',
                  color: primaryClr.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "You do not have any tasks yet! \n Add new tasks to make your days productive ",
                    style: subtitleStyle.copyWith(
                      color: provider.isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // SizedBox(height:120 ,
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }

  taskTile(index, context) {
    var provider = Provider.of<MyProvider>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: orangeClr,
        ),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${provider.tasks[index]['title']}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            '${provider.tasks[index]['sTime']}  -  ${provider
                                .tasks[index]['eTime']}',
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[100],
                                )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '${provider.tasks[index]['note']}',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                '${provider.tasks[index]['status']}',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
            isClose ? titleStyle.copyWith(color: Colors.black) : titleStyle,
          ),
        ),
      ),
    );
  }

  void showBottomSheets(BuildContext ctx,index) {
    var provider = Provider.of<MyProvider>(ctx, listen: false);
    showMaterialModalBottomSheet(
        context: ctx,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(

              width: double.infinity,
              height:provider.tasks[index]['status']=='TO DO'? 240:
              180,
              color: provider.isDark ? darkHeaderClr : Colors.white,
              child: Column(
                children: [
                  Flexible(child: Container(
                    height: 6,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: provider.isDark ? Colors.grey[600] : Colors
                            .grey[300]),
                  )),
                 const SizedBox(height: 15,),
                  provider.tasks[index]['status']=='TO DO'?
                  buildBottomSheet(
                      label: "Task Completed",
                      onTap: () {
                        provider.updateData(status: 'Completed', id:provider.tasks[index]['id']);
                        Navigator.pop(context);
                      },
                      clr: primaryClr):Container(),
                  buildBottomSheet(
                      label: "Delete Task",
                      onTap: () {
                        provider.deleteData( id:provider.tasks[index]['id']);
                        Navigator.pop(context);
                      },
                      clr: primaryClr),
                  Divider(
                    color: provider.isDark ? Colors.grey : darkGreyClr,
                  ),
                  buildBottomSheet(
                      label: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      clr: primaryClr),
                  const SizedBox(height: 15,),
                ],
              ),
            ),
          );
        });
  }
}
