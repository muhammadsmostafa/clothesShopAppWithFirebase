import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state){
          var searchModel = AppCubit.get(context).searchModel;
          var favorites = AppCubit.get(context).favorites;
            return WillPopScope(
              onWillPop: ()
              async {
                Navigator.pop(context);
                AppCubit.get(context).searchModel=[];
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                    title: Container(
                      height: 35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none
                          ),
                          controller: searchController,
                          onSubmitted: (value)
                          {
                            AppCubit.get(context).getSearch(searchWord: searchController.text.toLowerCase());
                          },
                        ),
                      ),
                    )
                ),
                body: SingleChildScrollView(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1 / 1.45,
                    children: List.generate(
                      searchModel.length,
                          (index) => buildGridProduct(searchModel[index], context, favorites, false),
                    ),
                  ),
                ),
              ),
            );
        }
    );
  }
}