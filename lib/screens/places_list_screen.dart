import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/places_detail_screen.dart';
import '../screens/add_place_screen.dart';

import 'package:great_locations/providers/great_places.dart';


class PlacesListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your places"),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pushNamed(AddPlaceScreen.routeName), icon: const Icon(Icons.add))
      ],),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshotResult) =>
          snapshotResult.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator(),)
              :
          Consumer<GreatPlaces>(
            child: Center(
                child: const Text("Got not places yet. Start adding some")),
                builder: (ctx, greatPlaces, ch) =>  greatPlaces.items.length <= 0 ? ch :
                ListView.builder(
                  itemBuilder: (ctx, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(
                          greatPlaces.items[index].image),
                    ),
                    title:Text( greatPlaces.items[index].title),
                    subtitle: Text(greatPlaces.items[index].location.address),
                    onTap: (){
                      Navigator.of(context).pushReplacementNamed(PlacesDetailScreen.routeName, arguments: greatPlaces.items[index].id);
                    },
                  ),
                  itemCount: greatPlaces.items.length,),
          ),
      )
    );
  }
}
