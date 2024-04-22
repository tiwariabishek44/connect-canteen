import 'dart:developer';

import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:flutter/material.dart';

class ListviewWidget extends StatelessWidget {
  final List<ProductQuantity> itemlist;
  final bool dashboard;

  const ListviewWidget(
      {Key? key, required this.itemlist, required this.dashboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(" this is  inside the listview widget  -------_${itemlist.length} ");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboard
          ? itemlist.length >= 3
              ? 3
              : itemlist.length
          : itemlist.length,
      itemBuilder: (context, index) {
        final productQuantity = itemlist[index];
        return ListTileContainer(
          name: productQuantity.productName,
          quantit: productQuantity.totalQuantity,
        );
      },
    );
  }
}
