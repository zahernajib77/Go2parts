import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as latLng;

class Map_page extends StatefulWidget {
  const Map_page({Key? key}) : super(key: key);

  @override
  _Map_pageState createState() => _Map_pageState();
}

class _Map_pageState extends State<Map_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Map"),backgroundColor: Colors.blue,) ,
      body: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(33.8547, 35.8623),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://api.mapbox.com/styles/v1/zahernajib/cl2m56ao3003414pgu2rjombi/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiemFoZXJuYWppYiIsImEiOiJjbDJtNHkyY20wazdlM2NuazdwamV5bGMxIn0.TPaPQ_nBYCWwyeTAIvHWfw",
              // subdomains: ['a', 'b', 'c'],
              additionalOptions: {
                'accessToken':'pk.eyJ1IjoiemFoZXJuYWppYiIsImEiOiJjbDJtNHkyY20wazdlM2NuazdwamV5bGMxIn0.TPaPQ_nBYCWwyeTAIvHWfw',
                'id':'mapbox.mapbox-terrain-dem-v1'
              }
            // attributionBuilder: (_) {
            //   return Text("© OpenStreetMap contributors");
            // },
          ),

          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: latLng.LatLng(34.540435, 36.188966),
                builder: (ctx) =>
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        color:Colors.red,
                        iconSize: 45,
                        onPressed: (){
                          print('on tapped');
                        },



                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );



  }
}
