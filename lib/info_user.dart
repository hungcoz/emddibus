// import 'dart:io';
//
// import 'package:emddi_bus/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'const_value.dart';
// import 'constants.dart';
// import 'menu.dart';
//
// class InfoUser extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _InfoUserState();
// }
//
// class _InfoUserState extends State<InfoUser> {
//   var _controller = new ScrollController();
//   bool silverCollapsed = false;
//   bool hasScroll = true;
//   String myTitle = "";
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//   var _controllerTextPhone = TextEditingController();
//   var _controllerTextUserName = TextEditingController();
//   var _controllerTextEmail = TextEditingController();
//
//   bool _isEnable = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controllerTextPhone.text = PHONE;
//   }
//
//   Widget _getImageWidget(){
//     if(FILE_AVATAR != null)
//       return CircleAvatar(
//         radius: 50,
//         backgroundImage: FileImage(FILE_AVATAR),
//       );
//     else return CircleAvatar(
//       radius: 50,
//       backgroundImage: AssetImage(PATH_AVATAR),);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(150),
//         child: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_outlined),
//             onPressed: (){
//               if(FILE_AVATAR != null){
//                 Navigator.pop(context, FILE_AVATAR);
//               }
//               else if(FILE_AVATAR == null)
//                 Navigator.pop(context, MaterialPageRoute(builder: (context) => Menu()));
//             },
//           ),
//           flexibleSpace: FlexibleSpaceBar(
//             centerTitle: true,
//             title: GestureDetector(
//               onTap: (){
//                 return showDialog(
//                   context: context,
//                   builder: (BuildContext context) => AlertDialog(
//                     title: Text("Vui lòng chọn ảnh"),
//                     content: Text("Chọn ảnh từ"),
//                     actions: [
//                       //choose images from gallery
//                       FlatButton(onPressed: ()async{
//                         File image = await ImagePicker.pickImage(source: ImageSource.gallery);
//                         if(image != null){
//                           File cropped = await ImageCropper.cropImage(
//                               sourcePath: image.path,
//                               aspectRatioPresets: [
//                                 CropAspectRatioPreset.square,
//                                 CropAspectRatioPreset.ratio3x2,
//                                 CropAspectRatioPreset.original,
//                                 CropAspectRatioPreset.ratio4x3,
//                                 CropAspectRatioPreset.ratio16x9
//                               ],
//                               androidUiSettings: AndroidUiSettings(
//                                   toolbarTitle: 'Cropper',
//                                   toolbarColor: Colors.amber,
//                                   toolbarWidgetColor: Colors.white,
//                                   initAspectRatio: CropAspectRatioPreset.original,
//                                   lockAspectRatio: false),
//                               iosUiSettings: IOSUiSettings(
//                                 minimumAspectRatio: 1.0,
//                               ));
//                           // print(cropped.path);
//                           setState(() {
//                             FILE_AVATAR = cropped;
//                             PATH_AVATAR = FILE_AVATAR.path;
//                           });
//                         }
//                         Navigator.pop(context);
//                       },
//                           child: Text("Bộ sưu tập")),
//                       //choose images from camera
//                       FlatButton(onPressed: ()async{
//                         File image = await ImagePicker.pickImage(source: ImageSource.camera);
//                         if(image != null){
//                           File cropped = await ImageCropper.cropImage(
//                               sourcePath: image.path,
//                               aspectRatioPresets: [
//                                 CropAspectRatioPreset.square,
//                                 CropAspectRatioPreset.ratio3x2,
//                                 CropAspectRatioPreset.original,
//                                 CropAspectRatioPreset.ratio4x3,
//                                 CropAspectRatioPreset.ratio16x9
//                               ],
//                               androidUiSettings: AndroidUiSettings(
//                                   toolbarTitle: 'Cropper',
//                                   toolbarColor: Colors.deepOrange,
//                                   toolbarWidgetColor: Colors.white,
//                                   initAspectRatio: CropAspectRatioPreset.original,
//                                   lockAspectRatio: false),
//                               iosUiSettings: IOSUiSettings(
//                                 minimumAspectRatio: 1.0,
//                               ));
//                           setState(() {
//                             FILE_AVATAR = cropped;
//                             PATH_AVATAR = FILE_AVATAR.path;
//                           });
//                         }
//                         Navigator.pop(context);
//                       },
//                         child: Text("Máy ảnh"),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: _getImageWidget(),
//             ),
//           ),
//           actions: [
//             PopupMenuButton<String>(
//               onSelected: (String value) {
//                 setState(() {
//                   if (value.contains("Đăng xuất")) {
//                     auth.signOut();
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Login()));
//                   }
//                   if (value.contains("Cập nhật thông tin")){
//                     _isEnable = true;
//                   }
//                 });
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                 PopupMenuItem(
//                   value: "Cập nhật thông tin",
//                   child: Text("Cập nhật thông tin"),
//                 ),
//                 PopupMenuItem(
//                   value: "Đăng xuất",
//                   child: Text("Đăng xuất"),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             //user name
//             Container(
//               margin: EdgeInsets.only(top: 10),
//               child: Row(
//                 children: [
//                   Container(
//                     child: Text("Họ và tên"),
//                     margin: EdgeInsets.only(right: 20, left: 10),
//                   ),
//                   Flexible(
//                     child: TextField(
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                       controller: _controllerTextUserName,
//                       enabled: _isEnable,
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.all(5),
//                           isDense: true),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Divider(),
//             //phone number
//             Container(
//               margin: EdgeInsets.only(top: 10),
//               child: Row(
//                 children: [
//                   Container(
//                     child: Text("Số điện thoại"),
//                     margin: EdgeInsets.only(right: 20, left: 10),
//                   ),
//                   Flexible(
//                     child: TextField(
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                       controller: _controllerTextPhone,
//                       enabled: _isEnable,
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.all(5),
//                           isDense: true),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Divider(),
//             //email
//             Container(
//               margin: EdgeInsets.only(top: 10),
//               child: Row(
//                 children: [
//                   Container(
//                     child: Text("Email"),
//                     margin: EdgeInsets.only(right: 20, left: 10),
//                   ),
//                   Flexible(
//                     child: TextField(
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                       controller: _controllerTextEmail,
//                       enabled: _isEnable,
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.all(5),
//                           isDense: true),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             // Divider(),
//             //button save
//             Container(
//               alignment: Alignment.centerRight,
//               margin: EdgeInsets.only(top: 10, right: 10),
//               child: Visibility(
//                 visible: _isEnable,
//                 child: FlatButton(
//                   color: Colors.amber,
//                   onPressed: (){
//                     setState(() {
//                       _isEnable = false;
//                     });
//                   },
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text("Lưu"),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       // body: CustomScrollView(
//       //   physics: AlwaysScrollableScrollPhysics(),
//       //   controller: _controller,
//       //   slivers: [
//       //     SliverAppBar(
//       //       floating: true,
//       //       pinned: true,
//       //       snap: true,
//       //       centerTitle: true,
//       //       backgroundColor: Colors.amber,
//       //       expandedHeight: 200,
//       //       flexibleSpace: FlexibleSpaceBar(
//       //         background: GestureDetector(
//       //           onTap: (){
//       //             return showDialog(
//       //                 context: context,
//       //               builder: (BuildContext context) => AlertDialog(
//       //               title: Text("Vui lòng chọn ảnh"),
//       //               content: Text("Chọn ảnh từ"),
//       //               actions: [
//       //                 FlatButton(onPressed: (){}, child: Text("Bộ sưu tập")),
//       //                 FlatButton(onPressed: ()async{
//       //                   File image = await ImagePicker.pickImage(source: ImageSource.camera);
//       //                   if(image != null){
//       //                     File cropped = await ImageCropper.cropImage(
//       //                         sourcePath: image.path,
//       //                         aspectRatioPresets: [
//       //                           CropAspectRatioPreset.square,
//       //                           CropAspectRatioPreset.ratio3x2,
//       //                           CropAspectRatioPreset.original,
//       //                           CropAspectRatioPreset.ratio4x3,
//       //                           CropAspectRatioPreset.ratio16x9
//       //                         ],
//       //                         androidUiSettings: AndroidUiSettings(
//       //                             toolbarTitle: 'Cropper',
//       //                             toolbarColor: Colors.deepOrange,
//       //                             toolbarWidgetColor: Colors.white,
//       //                             initAspectRatio: CropAspectRatioPreset.original,
//       //                             lockAspectRatio: false),
//       //                         iosUiSettings: IOSUiSettings(
//       //                           minimumAspectRatio: 1.0,
//       //                         ));
//       //                     setState(() {
//       //                       fileSelected = cropped;
//       //                     });
//       //                   }
//       //                 },
//       //                     child: Text("Máy ảnh"),
//       //                 ),
//       //               ],
//       //             ),
//       //             );
//       //           },
//       //           child: _getImageWidget(),
//       //         ),
//       //       ),
//       //       actions: [
//       //         PopupMenuButton<String>(
//       //           onSelected: (String value) {
//       //             setState(() {
//       //               if (value.contains("Đăng xuất")) {
//       //                 auth.signOut();
//       //                 Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                         builder: (context) => Login()));
//       //               }
//       //               if (value.contains("Cập nhật thông tin")){
//       //                 _isEnable = true;
//       //               }
//       //             });
//       //           },
//       //           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//       //             PopupMenuItem(
//       //               value: "Cập nhật thông tin",
//       //               child: Text("Cập nhật thông tin"),
//       //             ),
//       //             PopupMenuItem(
//       //               value: "Đăng xuất",
//       //               child: Text("Đăng xuất"),
//       //             )
//       //           ],
//       //         ),
//       //       ],
//       //     ),
//       //     SliverList(
//       //       delegate: SliverChildListDelegate(
//       //         [
//       //           Container(
//       //             child: Column(
//       //               children: [
//       //                 //user name
//       //                 Container(
//       //                   margin: EdgeInsets.only(top: 10),
//       //                   child: Row(
//       //                     children: [
//       //                       Container(
//       //                         child: Text("Họ và tên"),
//       //                         margin: EdgeInsets.only(right: 20, left: 10),
//       //                       ),
//       //                       Flexible(
//       //                         child: TextField(
//       //                           style: TextStyle(
//       //                             fontWeight: FontWeight.bold,
//       //                           ),
//       //                           controller: _controllerTextUserName,
//       //                           enabled: _isEnable,
//       //                           decoration: InputDecoration(
//       //                               contentPadding: EdgeInsets.all(5),
//       //                               isDense: true),
//       //                         ),
//       //                       )
//       //                     ],
//       //                   ),
//       //                 ),
//       //                 Divider(),
//       //                 //phone number
//       //                 Container(
//       //                   margin: EdgeInsets.only(top: 10),
//       //                   child: Row(
//       //                     children: [
//       //                       Container(
//       //                         child: Text("Số điện thoại"),
//       //                         margin: EdgeInsets.only(right: 20, left: 10),
//       //                       ),
//       //                       Flexible(
//       //                         child: TextField(
//       //                           style: TextStyle(fontWeight: FontWeight.bold),
//       //                           controller: _controllerTextPhone,
//       //                           enabled: _isEnable,
//       //                           decoration: InputDecoration(
//       //                               contentPadding: EdgeInsets.all(5),
//       //                               isDense: true),
//       //                         ),
//       //                       )
//       //                     ],
//       //                   ),
//       //                 ),
//       //                 Divider(),
//       //                 //email
//       //                 Container(
//       //                   margin: EdgeInsets.only(top: 10),
//       //                   child: Row(
//       //                     children: [
//       //                       Container(
//       //                         child: Text("Email"),
//       //                         margin: EdgeInsets.only(right: 20, left: 10),
//       //                       ),
//       //                       Flexible(
//       //                         child: TextField(
//       //                           style: TextStyle(
//       //                             fontWeight: FontWeight.bold,
//       //                           ),
//       //                           controller: _controllerTextEmail,
//       //                           enabled: _isEnable,
//       //                           decoration: InputDecoration(
//       //                               contentPadding: EdgeInsets.all(5),
//       //                               isDense: true),
//       //                         ),
//       //                       )
//       //                     ],
//       //                   ),
//       //                 ),
//       //                 // Divider(),
//       //                 //button save
//       //                 Container(
//       //                   alignment: Alignment.centerRight,
//       //                   margin: EdgeInsets.only(top: 10, right: 10),
//       //                   child: Visibility(
//       //                     visible: _isEnable,
//       //                       child: FlatButton(
//       //                         color: Colors.amber,
//       //                         onPressed: (){
//       //                           setState(() {
//       //                             _isEnable = false;
//       //                           });
//       //                         },
//       //                         shape: RoundedRectangleBorder(
//       //                           borderRadius: BorderRadius.circular(10),
//       //                         ),
//       //                         child: Text("Lưu"),
//       //                     ),
//       //                   ),
//       //                 )
//       //               ],
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     )
//       //   ],
//       // ),
//     );
//   }
// }
