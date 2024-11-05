import 'dart:async';

import 'package:flutter/material.dart';
import 'package:powagroup/ui/screen/modules/splash_module/splash/splash_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  // const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewMode>.reactive(
      viewModelBuilder: () => SplashViewMode(),
      onViewModelReady: (viewModel) {
        Timer(const Duration(seconds: 3), (() => viewModel.checkAutoLogin()));
      },
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset('assets/icon/splash.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                fit: BoxFit.cover),
            Positioned(
                top: 140,
                child: Image.asset('assets/icon/powagroup_logo.png',
                    fit: BoxFit.cover)),
          ],
        ),
      ),
    );
  }
}
