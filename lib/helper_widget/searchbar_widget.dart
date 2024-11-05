import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view_model.dart';
import 'package:powagroup/util/globleData.dart';

class SearchBarWidget extends StatelessWidget {
  final dynamic leading;
  final String? title;
  final dynamic subtitle;
  final dynamic trailing;
  final dynamic backColor;
  final double? height;
  final Widget? backIcon;
  final Widget? actionIcon;
  final SearchViewModel? viewModel;
  final bool? getsearchTap;

  const SearchBarWidget(
      {this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.backColor,
      this.height,
      this.backIcon,
      this.actionIcon,
      this.viewModel,
      this.getsearchTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        centerTitle: title != null && title!.isNotEmpty ? true : false,
        backgroundColor: const Color(0xffEFF1F2).withOpacity(0.0),
        leading: backIcon,
        leadingWidth: 40,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: TextField(
            focusNode: viewModel!.searchFieldFocus,
            controller: viewModel!.searchController,
            onChanged: (value) {
              viewModel!.isChangedEditField = true;

              if (value.isNotEmpty) {
                viewModel!.onItemChanged();
              } else {
                viewModel!.noDataFound = false;
                viewModel!.searchTap = false;
                viewModel!.clearList();

                viewModel!.getSearchLocaldata();
              }
            },
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              hintText: 'Search',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              hintStyle: TextStyle(
                  fontFamily: 'Raleway',
                  color: const Color(0xff858D93),
                  fontWeight: FontWeight.w400,
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
              suffixIcon: viewModel!.isChangedEditField
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () {
                          viewModel!.getSearchLocaldata();
                          viewModel!.searchController.clear();
                          viewModel!.clearList();
                          viewModel!.noDataFound = false;
                          viewModel!.searchTap = false;
                        },
                        icon: Icon(PowaGroupIcon.cross,
                            size: Globlas.deviceType == 'phone' ? 25 : 40),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(PowaGroupIcon.search_icon,
                            size: Globlas.deviceType == 'phone' ? 25 : 40),
                      ),
                    ),
            ),
          ),
        ));
  }
}
