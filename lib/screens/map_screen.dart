import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_locations/models/place.dart';


class MapScreen extends StatefulWidget {
  final PlaceLocation initPosition;
  final bool isSelecting;


  MapScreen({this.initPosition = const PlaceLocation(latitude: 37.36 , longitude:-122.10), this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position){
    setState(() {
      _pickedLocation = position;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your map"),
        actions: [
          if(widget.isSelecting)
            IconButton(onPressed: _pickedLocation == null ? null : (){
              Navigator.of(context).pop(_pickedLocation);
            },
              icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.initPosition.latitude,
                widget.initPosition.longitude),
            zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting) ? {}
            : {
          Marker(
              markerId: MarkerId('m1'),
              position: _pickedLocation ?? LatLng(
                                            widget.initPosition.latitude,
                                            widget.initPosition.longitude)
          ),
        },
      ),
    );
  }
}
