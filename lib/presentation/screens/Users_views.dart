import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';

import 'package:sight_mate_app/models/data_mode.dart';
import 'package:sight_mate_app/presentation/widgets/AddAnotherUser.dart';
import 'package:sight_mate_app/presentation/widgets/UserListtile.dart';

class UsersViews extends StatefulWidget {
  const UsersViews({super.key, required this.onTap, this.data});
  final Function() onTap;
  final List<DataModel>? data;

  @override
  State<UsersViews> createState() => _UsersViewsState();
}

class _UsersViewsState extends State<UsersViews> {
  List<DataModel> data = [];

  @override
  void initState() {
    widget.data != null ? data = widget.data! : data = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataCubit, DataState>(
      listener: (context, state) {
        if (state is GetDataSuccess) {
          data = state.data;
        } else if (state is GetDataError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UserListtile(
                      data: data[index],
                    );
                  },
                  itemCount: data.length,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                    onTap: () {
                      widget.onTap();
                    },
                    child: const Addanotheruser()),
                const SizedBox(height: 75),
              ],
            ),
          ),
        );
      },
    );
  }
}
