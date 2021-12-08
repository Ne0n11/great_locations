import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:great_locations/helpers/location_helper.dart';
import 'package:great_locations/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  String _previewImageUrl;

  void _showPreview(double lat, double lng){
    final previewURL = LocationHelper.generateLocationPreviewImage(longitude: lng, latitude: lat);
    setState(() {
      _previewImageUrl = previewURL;
    });
  }


  Future<void> _getCurrentUserLocation() async{
   try{
     final locationData = await Location().getLocation();
   _showPreview(locationData.latitude, locationData.longitude);
   widget.onSelectPlace(locationData.longitude, locationData.latitude);
   }catch(error){return;}
  }

  Future<void> _selectOnMap() async{
   final selectedLocation =  await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => MapScreen(
        isSelecting: true,
      ))
    );
   if(selectedLocation == null){return;}
   widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    _showPreview(selectedLocation.longitude, selectedLocation.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        height: 170,
        width: double.infinity,
        child: _previewImageUrl == null ?
        Text("No location chosen",
          textAlign: TextAlign.center,) :
        Image.network(
          _previewImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _getCurrentUserLocation,
            icon: Icon(Icons.location_on),
            label: Text("Current location"),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
          ),),
          TextButton.icon(
            onPressed: _selectOnMap,
            icon: Icon(Icons.map),
            label: Text("Select on map"),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),),
        ],
      )
    ],);
  }
}
