import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'classes.dart';
import 'dart:convert' show json;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  String imageURL =
      "";
  List<Camera> cameras = [];
  Future<TrafficMainJSON> fetchPost() async {
    final response =
        await http.get('https://api.data.gov.sg/v1/transport/traffic-images');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return TrafficMainJSON.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final thing = fetchPost();

    thing.then((value) {
      setState(() {
        _markers.clear();
        cameras = value.items[0].cameras;
        for (final cameraLocation in value.items[0].cameras) {
          final marker = Marker(
            onTap: () {
              setState(() {
                imageURL = cameraLocation.image;
              });
            },
            markerId: MarkerId(cameraLocation.camera_id),
            position: LatLng(cameraLocation.latitude, cameraLocation.longitude),
            // infoWindow: InfoWindow(
            //   title: "Singapore",
            //   snippet: "Singapore address",
            //   onTap: (){
            //     setState(() {
            //       imageURL = cameraLocation.image;
            //   });
            //   }
            // ),
          );
          _markers[cameraLocation.camera_id] = marker;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            
            appBar: AppBar(
              
              title: const Text('SG Live Traffic Cameras'),
              backgroundColor: Colors.green[700],
            ),
            body: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Column(
                children: <Widget>[
                  (imageURL == ""
                      ? Container(height: 282, child: Text("\n\n\n\nClick on the map marker to display the traffic image",textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.none,fontSize: 22,color: Colors.grey),),)
                      : Container(
                          height: 282,
                          child: Image.network(imageURL)
     
                        )),
                  Expanded(
                    child: Container(
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: false,
                        trafficEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: const LatLng(1.3435, 103.86),
                          zoom: 12,
                        ),
                        markers: _markers.values.toSet(),
                      ),
                    ),
                  )
                ],
              ),
            )),
      );
}
