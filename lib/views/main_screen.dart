import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/views/categories_screen.dart';
import 'package:helpiflyadmin/views/items_screen.dart';
import 'package:helpiflyadmin/views/requests_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    ItemsScreen(),
    const RequestsScreen(),
    CategoriesScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<AppCubit>().setCurrentTabIndex(index);
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AppCubit>().loadItems();
    context.read<AppCubit>().loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return _screens[state.currentTabIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Items',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.web),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Categories',
              ),
            ],
            currentIndex: state.currentTabIndex,
            onTap: (index) => _onItemTapped(context, index),
            selectedItemColor: grayColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: inCardColor,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
