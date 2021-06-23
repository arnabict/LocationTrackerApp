import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/home_screen.dart';

class ChangeProfilePicture extends StatefulWidget {
  static const routeName = '/change_profile_picture';

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  Dio dio = Dio();
  File _futureImage;

  Future getImage() async {
    final futureImagePicker = ImagePicker();
    final futureImage =
        await futureImagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      File imageFile = File(futureImage.path);
      _futureImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Profile Picture", style: GoogleFonts.lato()),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.white,
              Colors.blueGrey,
            ])),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 200.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Color(0xff004080),
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Select an Image",
                              style: GoogleFonts.mcLaren(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: getImage),
                ),
                _futureImage == null
                    ? Text("Image is not selected. Please select an Image.")
                    : ClipOval(
                        child: Image.file(
                          _futureImage,
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                Container(
                  width: 200.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color(0xff004080),
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Upload Image",
                            style: GoogleFonts.mcLaren(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.upload_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onPressed: () async {
                      // File image;
                      // final picker = ImagePicker();
                      // var imagePicker =
                      //     await picker.getImage(source: ImageSource.gallery);
                      // if (imagePicker != null) {
                      //   setState(() {
                      //     File file = File(imagePicker.path);
                      //     image = file;
                      //   });
                      // }
                      try {
                        String fileName = _futureImage.path.split('/').last;
                        FormData formData = FormData.fromMap({
                          "user_id": myUserId,
                          "image": await MultipartFile.fromFile(
                              _futureImage.path,
                              filename: fileName,
                              contentType: MediaType("image", "jpg")),
                          "type": "image/png",
                        });
                        Response response = await dio.post(
                            "https://location.timetechri.co.uk/api/location/update/profile",
                            data: formData,
                            options: Options(headers: {
                              "accepts": "*/*",
                              "Authentication": "Bearer" + myToken.toString(),
                              "Content-Type": "multipart/form.data",
                            }));
                        print(response.data);
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
//   Future<File> file;
//   String status = "";
//
//   chooseImage() {
//     setState(() {
//       file = ImagePicker.picImage(source: ImageSource.gallery);
//     });
//   }
//
//   startUpload() {}
//
//   Widget showImage() {
//     return FutureBuilder<File>(
//       future: file,
//       builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             null != snapshot.data) {
//           return Flexible(
//               child: Image.file(
//             snapshot.data,
//             fit: BoxFit.fill,
//           ));
//         } else if (null != snapshot.error) {
//           return const Text(
//             "Error Picking Image",
//             textAlign: TextAlign.center,
//           );
//         } else
//           return const Text(
//             "No Image Selected",
//             textAlign: TextAlign.center,
//           );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload Photo", style: GoogleFonts.lato()),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//               Colors.white,
//               Colors.blueGrey,
//             ])),
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 OutlinedButton(
//                     onPressed: chooseImage, child: Text("Select an image")),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 showImage(),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 OutlinedButton(
//                     onPressed: startUpload, child: Text("Upload image")),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Text(
//                   status,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.comicNeue(color: Colors.teal),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
