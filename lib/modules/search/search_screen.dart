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
                    title: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        Container(
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
                              onChanged: (value){
                                AppCubit.get(context).setState();
                              },
                              controller: searchController,
                              onSubmitted: (value)
                              {
                                if(value.isNotEmpty)
                                {
                                  AppCubit.get(context).getSearch(searchWord: searchController.text.toLowerCase());
                                }
                              },
                            ),
                          ),
                        ),
                        if(searchController.value.text.isNotEmpty)
                          IconButton(
                              onPressed: ()
                              {
                                searchController.clear();
                                AppCubit.get(context).setState();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey
                              ))
                      ],
                    )
                ),
                body: SingleChildScrollView(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: (MediaQuery.of(context).size.width*0.5) / ((MediaQuery.of(context).size.width*0.5)+91),
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