import 'package:flutter/foundation.dart';
import '../models/place.dart';
import 'package:great_locations/helpers/db_helper.dart';
import 'package:great_locations/helpers/location_helper.dart';
import 'dart:io';

class GreatPlaces with ChangeNotifier{
  List<Place> _items = [];

  List<Place> get items{ // get a copy of _items
    return [..._items];
  }

  Place findById(String id){
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(String title, File image, PlaceLocation pickedLoc) async{
    final address = await LocationHelper.getPlaceAddress(pickedLoc.latitude, pickedLoc.longitude);
    final updatedLocation = PlaceLocation(latitude: pickedLoc.latitude, longitude: pickedLoc.longitude, address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        image: image,
        location: updatedLocation);

    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
        'user_places',
        {'id':newPlace.id,
          'title':newPlace.title,
          'image':newPlace.image.path,
          'loc_lat': newPlace.location.latitude,
          'loc_lng': newPlace.location.longitude,
          'address': newPlace.location.address
        });
  }


  Future<void> fetchAndSetPlaces() async{
    final dataList = await DBHelper.getData('user_places');
    _items = dataList.map((item) => Place(
      id: item['id'],
      title: item['title'],
      image: File(item['image']),
      location: PlaceLocation(
          latitude: item['loc_lat'],
          longitude:item['loc_lng'],
          address:item['address']),
    )).toList();
    notifyListeners();
  }

}