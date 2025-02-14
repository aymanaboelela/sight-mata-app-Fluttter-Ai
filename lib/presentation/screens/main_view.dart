import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/models/data_mode.dart';
import 'package:sight_mate_app/presentation/screens/Distance_Off_view.dart';

import 'package:sight_mate_app/presentation/screens/StartJourney_view.dart';
import 'package:sight_mate_app/presentation/screens/Users_views.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PageController controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    isData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPage = controller.page!.toInt();
      });
    });
  }

  void isData() async {
    dataList = await context.read<DataCubit>().getData();

    if (dataList != null && dataList!.isNotEmpty) {
      controller.jumpToPage(2);
      _currentPage = 0;

      setState(() {});
      print(dataList);
    }
  }

  List<DataModel>? dataList;
  String name = CacheData.getData(key: userNameUser) ?? 'User';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is GetDataLoading,
          progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryBlueColor,
              title: Row(
                children: [
                  _currentPage == 0 || _currentPage == 2
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            dataList =
                                await context.read<DataCubit>().getData();
                            controller.animateToPage(2,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xff94B2C8),
                    child: Icon(
                      Icons.person_outlined,
                      color: Color(0xff7897AD),
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Bahnschrift',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Visibility(
                  visible: state is GetDataLoading || dataList!.isNotEmpty
                      ? false
                      : true,
                  child: StartJourney(
                    onTap: () {
                      controller.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
                DistanceOffView(
                  onTap: () {
                    controller.animateToPage(2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
                UsersViews(
                  data: dataList,
                  onTap: () {
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
