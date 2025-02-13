import 'package:flutter/material.dart';
import 'package:sight_mate_app/presentation/widgets/AddAnotherUser.dart';
import 'package:sight_mate_app/presentation/widgets/UserListtile.dart';

class UsersViews extends StatelessWidget {
  const UsersViews({super.key, required this.onTap});
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          UserListtile(),
          SizedBox(
            height: 75,
          ),
          Addanotheruser()
        ],
      ),
    );
  }
}
