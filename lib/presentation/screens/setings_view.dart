import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/PopMenuListtile.dart';

import '../../controllers/auth/auth_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
      child: Column(
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push(AppRouter.KMyProfileView),
            child: const Popmenulisttile(
              title: "My Profile",
              icon: Icons.person,
            ),
          ),
          InkWell(
            onTap: () => GoRouter.of(context).push(AppRouter.kAboutView),
            child: const Popmenulisttile(
              title: "About",
              icon: Icons.settings,
            ),
          ),
          InkWell(
            onTap: () {
              GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
              context.read<AuthCubit>().signOut();
            },
            child: const Popmenulisttile(
              title: "Logout",
              icon: Icons.logout,
            ),
          )
        ],
      ),
    );
  }
}
