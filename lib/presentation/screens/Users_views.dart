import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        } else if (state is DeleteDataSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        } else if (state is DeleteDataError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () {
            return context.read<DataCubit>().getData();
          },
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Call delete method from the cubit
                                context.read<DataCubit>().deleteData(
                                      id: data[index].id!,
                                    );
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: UserListtile(
                          data: data[index],
                        ),
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
