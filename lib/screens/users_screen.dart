// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              title: Text(
            AppLocalizations.of(context)!.group,
            style: Theme.of(context).textTheme.headline2,
          )),
          body: ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(photos[index]),
                  ),
                  title: Text(
                    names[index],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  subtitle: Text(emails[index]),
                );
              }),
        );
      },
    );
  }
}
