import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_submission.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/show_info.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/home_screen.dart';

// API Key in Google Cloud Platform

class QuesAns {
  QuesAns({
    this.userId,
    this.stallName,
    this.stallDes,
    this.latitude,
    this.longitude,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String userId;
  String stallName;
  String stallDes;
  String latitude;
  String longitude;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory QuesAns.fromJson(Map<String, dynamic> json) => QuesAns(
        userId: json["user_id"],
        stallName: json["stall_name"],
        stallDes: json["stall_des"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "stall_des": stallDes,
        "latitude": latitude,
        "longitude": longitude,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}

class MyMap extends StatefulWidget {
  static const routeName = '/google_map';

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Future<QuesAns> futureResponse;
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;

  Future<QuesAns> submitRequest(
      String userId,
      String stallName,
      String stallDes,
      String latitude,
      String longitude,
      String accessToken) async {
    final http.Response response = await http.post(
      Uri.parse(
          "https://location.timetechri.co.uk/api/location/question/info/submit"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'stall_name': stallName,
        'stall_des': stallDes,
        'latitude': latitude,
        'longitude': longitude,
        'token': accessToken,
      }),
    );

    print(json.decode(response.body));
    if (response.statusCode == 200) {
      return QuesAns.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  void initState() {
    super.initState();
    setCustomMarker();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/map_pin_128.png");
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("id-1"),
          position: LatLng(latDouble, longDouble),
          icon: mapMarker,
          infoWindow: InfoWindow(title: "My Location")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Location",
            style: GoogleFonts.mcLaren(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
        actions: [
          FlatButton(
            color: Colors.teal,
            child: Row(
              children: [
                Text("SUBMIT",
                    style: GoogleFonts.comicNeue(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 5.0),
                Icon(Icons.app_registration)
              ],
            ),
            onPressed: () {
              setState(() {
                print(shopNameController.text);
                print(shopDetailsController.text);
                futureResponse = submitRequest(
                    myUserId.toString(),
                    shopNameController.text,
                    shopDetailsController.text,
                    latDouble.toString(),
                    longDouble.toString(),
                    myToken);
              });
              futureResponse.then((value) => Navigator.of(context)
                  .pushReplacementNamed(LoadingScreenSubmission.routeName));
            },
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        markers: _markers,
        initialCameraPosition:
            CameraPosition(target: LatLng(latDouble, longDouble), zoom: 15),
      ),
    );
  }
}
