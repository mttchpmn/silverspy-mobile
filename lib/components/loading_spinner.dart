import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        ]);
  }
}
