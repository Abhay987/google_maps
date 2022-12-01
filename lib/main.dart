import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_size/flutter_size.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps/direction_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'direction_modal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Completer<GoogleMapController> mapController = Completer();
  MapType mapType = MapType.normal;

  GoogleMapController? googleMapController;
  //Toggling UI as we need
  bool searchToggle = false,directionToggle = false;

  TextEditingController searchController = TextEditingController();

  //Direction Showing
  Marker? origin,destination;

  // Directions? info;

@override
  void dispose() {
    super.dispose();
    googleMapController!.dispose();
  }

  //initial Map Position on load
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(28.644541609372386, 77.32656612443255),
    zoom: 14.4746,
  );


  Directions? info;
  //Markers set
  // Set<Marker> markers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 5,
        spacing: 5,
        backgroundColor: Colors.black,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onTap: (){
              if(mapType == MapType.normal) {
                  mapType = MapType.satellite;
              }
              else {
                mapType = MapType.normal;
              }
              setState(() {
              });
            },
            child: const Icon(Icons.satellite_alt),
            label: 'Map Mode'
          ),

          // Search Widget
          SpeedDialChild(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onTap: (){
                searchToggle = !searchToggle;
                setState(() {
                });
              },
              child: const Icon(Icons.search),
              label: 'Search'
          ),

          // Direction Widget
          SpeedDialChild(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onTap: (){
                directionToggle = !directionToggle;
                setState(() {
                });
              },
              child: const Icon(Icons.directions),
              label: 'Direction'
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(width: context.deviceWidth,
            height: context.deviceHeight,
            child: GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              polylines: {
                if(info!=null)
                  Polyline(polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList()),
              },
              // markers: markers,
              markers: {
                if(origin!=null) origin!,
                if(destination!=null) destination!
              },
              onTap: addMarker,
              // onLongPress: addMarker,
              onMapCreated: (controller){
                googleMapController = controller;
                // mapController.complete(controller);
              },
              initialCameraPosition: initialCameraPosition,
              mapType: mapType,
            ),
          ),
        info !=null ?
            Positioned(bottom: 20.0,child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black26,
                  offset: Offset(0,2),
                    blurRadius: 6.0
                  )
                ]
              ),
              child: Text('${info!.totalDistance} , ${info!.totalDuration}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ),) : const SizedBox.shrink(),
          
          // Search Toggle
          searchToggle ? Padding(padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        onPressed: (){
                          searchToggle = !searchToggle;
                          searchController.text = '';
                          setState(() {
                          });
                        },icon: const Icon(Icons.close),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
                    ),
                    onChanged: (value){
                    
                    },
                  ),
                ),
              ],
            ),
          ) : const SizedBox.shrink(),

          // Direction Toggle
          directionToggle ? Padding(padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Google Maps'),
                      if(origin != null)
                      TextButton(style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                          onPressed: (){
                        googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: origin!.position,zoom: 14.5,tilt: 50.0)));
                      }, child: const Text('ORIGIN')),
                      if(destination != null)
                        TextButton(style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                            onPressed: (){
                              googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination!.position,zoom: 14.5,tilt: 50.0)));
                            }, child: const Text('DEST')),
                    ],
                  ),
                ),
              ],
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    ));
  }

  void addMarker(LatLng pos) async{
    if(origin == null || origin != null && destination != null) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin


        origin = Marker(markerId: const MarkerId("origin"),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: pos);


      destination = null;
      info = null;
setState(() {

});

    }
    else {
      // Origin is already set
      // Set destination

      setState(() {
        destination = Marker(markerId: const MarkerId("destination"),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos);
      });

     var directionData = await DirectionRepository.getDirections(origin: origin!.position, destination: pos);

      setState(() {
        info = directionData;
      });

    }
  }

}









/// Flutter Google Map Simple/Default Example

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}