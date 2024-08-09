import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/models/item_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 2,
        title: Text(
          "All Categories",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: grayColor, borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      String thisCategory = state.categories[index];
                      return Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: inCardColor,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          thisCategory,
                          style: TextStyle(color: white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
