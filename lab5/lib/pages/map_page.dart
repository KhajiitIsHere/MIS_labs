import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List<Marker> markers;
  final void Function() toggleMap;

  const MapPage({
    super.key,
    this.markers = const [],
    required this.toggleMap,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(41.99889343239384, 21.38969315735255);

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _createPolylines() async {
    final PolylinePoints polylinePoints = PolylinePoints();

    final destination = widget.markers.first.position;

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAvX04Q2eBfqU_VxTBz0Me2hHR6JSYKf7w', // Google Maps API Key
      PointLatLng(_center.latitude, _center.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    final List<LatLng> polylineCoordinates = [];

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    setState(() {
      polylines[id] = polyline;
    });
  }

  get currentLocationMarker {
    return Marker(
        markerId: const MarkerId('my_location'),
        position: _center,
        infoWindow: const InfoWindow(title: 'Current location'));
  }

  @override
  Widget build(BuildContext context) {
    print(_center);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Map'),
          centerTitle: true,
          leading: IconButton(
            onPressed: widget.toggleMap,
            icon: const Icon(Icons.arrow_back),
          )),
      body: GoogleMap(
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: _onMapCreated,
        markers: {currentLocationMarker, ...widget.markers},
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: _createPolylines, child: const Icon(Icons.directions)),
    );
  }
}
