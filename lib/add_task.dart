import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/colors.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/home_page.dart';
import 'package:todoapp/provider.dart';

class AddTaskPage extends StatefulWidget {
   const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
 final x=GlobalKey<ScaffoldState>();
  final  titleController=TextEditingController();
 String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
 String endTime = DateFormat('hh:mm a')
     .format(DateTime.now().add(const Duration(minutes: 15)))
     .toString();
 final  noteController=TextEditingController();
  DateTime selectedDate =DateTime.now();
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<MyProvider>(context);
    return Scaffold(
      key: x,
      backgroundColor: context.theme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(
                context,
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: primaryClr,
                  ),
                )),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 20),
              child:Column(
                children: [
                  Text(
                    "Add Task",
                    style: headingStyle.copyWith(
                      color: provider.isDark?Colors.white:Colors.black,
                    ),
                  ),
                  InputField(
                    title: 'Title',
                    hint: 'Enter title here',
                    controller: titleController,),
                  InputField(title: 'Note',
                    hint: 'Enter Note here',
                    controller: noteController
                    ,),
                  InputField(
                    title: 'Date',
                    onTap: (){getDateFromUser();},
                    hint: DateFormat.yMd().format(
                     selectedDate
                    ),
                    widget: IconButton(
                      onPressed: (){getDateFromUser();},
                      icon:const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey,),
                    ),


                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          onTap:  (){getTimeFromUser( isStartTime: true);},
                          title: 'Start Time',
                          hint: startTime,
                          widget: IconButton(
                            onPressed: (){
                              getTimeFromUser( isStartTime: true);
                            },
                            icon:const Icon(Icons.access_time_rounded),
                          ),
                        ),
                      ),
                     const SizedBox(width:15 ,),
                      Expanded(
                        child: InputField(
                          onTap:  (){getTimeFromUser( isStartTime: false);},
                          title: 'End Time',
                          hint:endTime,
                          widget: IconButton(
                            onPressed: (){getTimeFromUser( isStartTime: false);},
                            icon:const Icon(Icons.access_time_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height: 30,),
                  Button(
                      label:'Create Task',
                     onTap: (){
                        validateDate();
                     },
                    width:  double.infinity)
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  getDateFromUser( ) async{


    DateTime ?pickerDate=await showDatePicker(
        context: context,
        initialDate:selectedDate ,
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
    );
    if(pickerDate!=null){
     setState((){
       selectedDate=pickerDate;
     });
    }
    else{
      print("Date Null");
    }
  }
  getTimeFromUser({required bool isStartTime})async{

    TimeOfDay?pickedTime=await showTimePicker(
        context: context,
        initialTime: isStartTime?
            TimeOfDay.fromDateTime(DateTime.now()):
            TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15)))
    );
    String formattedTime=pickedTime!.format(context);
    if(isStartTime){
      setState((){
        startTime=formattedTime;
      });

    }
    if(!isStartTime){
      setState((){
        endTime=formattedTime;
      });
    }
    else{
      print('time wrong');
    }
  }

 validateDate(){
   var provider=Provider.of<MyProvider>(context,listen: false);
   if(titleController.text.isNotEmpty &&
       noteController.text.isNotEmpty){
     print('dk');
     provider.insertToDataBase(
       title:titleController.text ,
       date:selectedDate.toString(),
       note: noteController.text,
       sTime: startTime,
       eTime: endTime,
     ).then((value){
        navigatorTo(context,const HomePage());
     });
   }
   else if(titleController.text.isEmpty||
       noteController.text.isEmpty){
     final sBar=SnackBar(

       content: SizedBox(
         height: 45,
         width: double.infinity,
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            const Icon(Icons.warning_amber_outlined,color: Colors.red,),
           const  SizedBox(width: 15,),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children:const [
                 Text("required",style:
                 TextStyle(fontWeight: FontWeight.w800,
                     color: Colors.red,
                     fontSize: 16),),
                 SizedBox(height: 6,),
                 Text("All fields are required!",
                   style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.w300,
                     color: Colors.red
                   ),
                 )

               ],
             )
           ],
         ),
       ),
       backgroundColor: Colors.white,
       duration:const Duration(seconds: 4),
     );
     x.currentState!.showSnackBar(sBar);
   }
   else{
     print("********Smoothing *********");
   }
 }
}
