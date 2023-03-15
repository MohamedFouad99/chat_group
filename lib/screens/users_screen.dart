// ignore_for_file: must_be_immutable

import 'package:chat_group/constant/constant_color.dart';
import 'package:chat_group/cubits/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  static const String screenRoute = 'users_screen';

  UsersScreen({super.key});
  List<String> names = [];
  List<String> emails = [];
  List<String> photos = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          names = state.names;
          emails = state.emails;
          photos = state.photos;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: ksecondryColor,
              title: const Text('Group Member')),
          body: ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(photos[index]),
                  ),
                  title: Text(names[index]),
                  subtitle: Text(emails[index]),
                );
              }),
        );
      },
    );
  }
}
