import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DeliveryAgentLocationDialog extends StatefulWidget {
  final String orderId;
  final String? restaurantId;

  const DeliveryAgentLocationDialog({super.key, required this.orderId, this.restaurantId});

  @override
  State<DeliveryAgentLocationDialog> createState() => _DeliveryAgentLocationDialogState();
}

class _DeliveryAgentLocationDialogState extends State<DeliveryAgentLocationDialog>
{
  late Future<Map<String, dynamic>> _locationDataFuture;
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    _locationDataFuture = _fetchLocations();
  }

  Future<Map<String, dynamic>> _fetchLocations() async
  {
    final agent = await OrderService().getLastDeliveryAgentLocation(orderID: widget.orderId);
    final restaurant = await RestaurantServices().getRestaurantByUserID(widget.restaurantId!);

    if (agent == null || restaurant == null) {
      throw Exception("Failed to load either agent or restaurant data.");
    }

    return {
      'agent': agent,
      'restaurant': restaurant,
    };
  }

  void _refresh() {
    setState(() {
      _locationDataFuture = _fetchLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _locationDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final agent = snapshot.data!['agent'] as CurrentDeliveryAgentModal;
          final restaurant = snapshot.data!['restaurant'] as PartnerModel;

          //Agent Latitude and Longitude
          final double? agentLat = double.tryParse(agent.latidute ?? '');
          final double? agentLng = double.tryParse(agent.longitude ?? '');

          //Restaurant Latitude and Longitude
          final double? restLat = double.tryParse(restaurant.latitude ?? '');
          final double? restLng = double.tryParse(restaurant.longitude ?? '');



          if ([agentLat, agentLng, restLat, restLng].contains(null)) {
            return const Center(child: Text("Invalid coordinates"));
          }

          final LatLng agentPos = LatLng(agentLat!, agentLng!);
          final LatLng restPos = LatLng(restLat!, restLng!);


          //Restaurant and Rider Marker or Icons to show on map

          final markers = {
            Marker(
              markerId: const MarkerId('agent'),
              position: agentPos,
              infoWindow: const InfoWindow(title: 'Delivery Agent'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
            Marker(
              markerId: const MarkerId('restaurant'),
              position: restPos,
              infoWindow: const InfoWindow(title: 'Restaurant'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          };


          //Connection line between Restaurant and Rider
          final polyline = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [restPos, agentPos],
              color: mainColor,
              width: 4,
            ),
          };


          return Column(
            children: [
              SizedBox(
                height: 400,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: restPos,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _googleMapController = controller;
                  },
                  markers: markers,
                  polylines: polyline,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer())
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _refresh,
                  child: const Text(
                    "Refresh",
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

