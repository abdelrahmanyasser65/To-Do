import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/colors.dart';

import '../provider.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.label, required this.onTap,
    required this.width})
      : super(key: key);
  final String label;
  final Function() onTap;
 final   double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        width: width,
        height: 45,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

navigatorTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
buildAppBar(ctx,leading){

  return Container(
    margin:const EdgeInsets.only(
      top: 50,
    ),
    child:Row(
      children: [
        leading,
        const  Spacer(),
        const  CircleAvatar(
          backgroundImage: AssetImage('assets/person.jpeg'),
          radius: 18,
        ),
        const  SizedBox(width: 20,),
      ],
    ),

  );}
class InputField extends StatelessWidget {
   const InputField(
      {Key? key,
        required this.title,
        required this.hint,
        this.onTap,
        this.controller,
        this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final  onTap;

  @override
  Widget build(BuildContext context) {
    var provider=  Provider.of<MyProvider>(context);
    return Container(
      margin:const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: titleStyle.copyWith(
            color: provider.isDark?Colors.white:Colors.black
          ),),
          Container(
            width: double.infinity,
            height: 52,
            padding: const EdgeInsets.only(left: 14),
            margin:const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(child: TextFormField(
                  controller: controller,
                  onTap:onTap ,
                  cursorColor:
                  provider.isDark?Colors.grey[100]:Colors.grey[700],
                  readOnly:widget!=null?true:false ,
                  autofocus: false,
                  style:GoogleFonts.lato(
                      textStyle: TextStyle(
                        color:provider.isDark? Colors.white:Colors.black
                        ,fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )
                  ),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: context.theme.backgroundColor,

                        )
                    ),
                    focusedBorder:  UnderlineInputBorder(

                        borderSide: BorderSide(
                          width: 0,
                          color: context.theme.backgroundColor,

                        )
                    ),
                    hintText:hint,
                    hintStyle: subtitleStyle.copyWith(
                      color: provider.isDark?Colors.white:Colors.black
                    ),


                  ),
                )),
                widget??Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
