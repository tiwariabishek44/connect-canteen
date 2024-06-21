// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:connect_canteen/app1/cons/colors.dart';
// import 'package:connect_canteen/app1/model/student_model.dart';
// import 'package:connect_canteen/app1/model/wallet_model.dart';
// import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
// import 'package:connect_canteen/app1/modules/common/wallet/wallet_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class UserINformationSection extends StatelessWidget {
//   UserINformationSection({super.key});
//   final transctionController = Get.put(TransctionController());
//   final loignController = Get.put(LoginController());

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<StudentDataResponse?>(
//       stream: loignController.getStudetnData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container();
//         } else if (snapshot.hasError) {
//           return SizedBox.shrink();
//         } else if (snapshot.data == null) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\Rs.0', // Display total balance
//                 style: TextStyle(
//                   fontSize: 38,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 'Wallet BALANCE',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               SizedBox(height: 30),
//             ],
//           );
//         } else {
//           StudentDataResponse studetnData = snapshot.data!;
//           log("${loignController.studentDataResponse.value!.classes}");

//           return Column(
//             children: [
//               Container(
//                 width: 100.w,
//                 height: 12.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Color.fromARGB(255, 255, 255, 255),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start, // Added this line
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${studetnData.name}! 👋',
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color.fromARGB(255, 70, 69, 69),
//                               ),
//                             ),
//                             Text(
//                               '${studetnData.classes}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromARGB(179, 50, 49, 49),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       CircleAvatar(
//                         radius: 21.sp,
//                         backgroundColor: Colors.white,
//                         child: studetnData.name == ''
//                             ? CircleAvatar(
//                                 radius: 21.sp,
//                                 backgroundColor: Colors.white,
//                               )
//                             : CachedNetworkImage(
//                                 progressIndicatorBuilder:
//                                     (context, url, downloadProgress) =>
//                                         CircularProgressIndicator(
//                                             value: downloadProgress.progress),
//                                 imageUrl: studetnData.profilePicture,
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 errorWidget: (context, url, error) => Icon(
//                                   Icons.person,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 3.h,
//               ),
//               StreamBuilder<Wallet?>(
//                 stream: transctionController.getWallet(studetnData.userid),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return SizedBox.shrink();
//                   } else if (snapshot.hasError) {
//                     log(" this is error :::::${snapshot.error}");
//                     return SizedBox.shrink();
//                   } else if (snapshot.data == null) {
//                     return Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromARGB(255, 237, 240, 240),
//                             Color.fromARGB(255, 218, 218, 218)
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color.fromARGB(66, 109, 109, 109),
//                             blurRadius: 1,
//                             offset: Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Wallet BALANCE',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: const Color.fromARGB(179, 60, 58, 58),
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             '\NPR 0.00',
//                             style: TextStyle(
//                               fontSize: 27.sp,
//                               fontWeight: FontWeight.bold,
//                               color: const Color.fromARGB(255, 17, 17, 17),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     Wallet wallet = snapshot.data!;
//                     Map<String, double> totals = transctionController
//                         .calculateTotals(wallet.transactions);
//                     double totalBalance = totals['totalBalance'] ?? 0.0;

//                     return Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromARGB(255, 245, 255, 255),
//                             Color.fromARGB(255, 200, 232, 200)
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color.fromARGB(66, 109, 109, 109),
//                             blurRadius: 1,
//                             offset: Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Wallet BALANCE',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: const Color.fromARGB(179, 60, 58, 58),
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             '\NPR $totalBalance',
//                             style: TextStyle(
//                               fontSize: 27.sp,
//                               fontWeight: FontWeight.bold,
//                               color: const Color.fromARGB(255, 17, 17, 17),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               )
//             ],
//           );
//         }
//       },
//     );
//   }
// }
