import 'package:flutter/material.dart';

class MyPfrofileTextFormField extends StatelessWidget {
  const MyPfrofileTextFormField({super.key, required this.label, required this.hintText});
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          const SizedBox(height: 5,),
          TextFormField( 
          decoration:   InputDecoration(
              hintText: hintText,
              hintStyle:
                  const TextStyle(fontSize: 14, color:Colors.grey),
                   enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xffD5D5D5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.black),
              )
              
          ),
      )],
      ),
    );
  }
}
