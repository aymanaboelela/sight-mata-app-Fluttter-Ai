import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/models/data_mode.dart';

class UserListtile extends StatelessWidget {
  const UserListtile({super.key, required this.data});
  final DataModel data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushReplacement(AppRouter.kUserLocationNow);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15, top: 20),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          border: Border.all(color: const Color(0xffBFC9D0), width: 1.2),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.person_outlined,
            size: 40,
            color: Colors.grey,
          ),
          title: Text(
            data.username,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_forward,
              size: 35,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
