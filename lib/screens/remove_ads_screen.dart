import 'package:flutter/material.dart';

import '../widgets/remove_ads_body.dart';

class RemoveAdsScreen extends StatelessWidget {
  const RemoveAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RemoveAdsBody(onBack: () => Navigator.of(context).pop()),
    );
  }
}
