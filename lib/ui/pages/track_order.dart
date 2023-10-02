import 'package:amber_bird/data/dhl/shipment.shipping.dart';
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import '../../controller/order-controller.dart';
import '../../data/dhl/event.shipping.dart';
import '../../helpers/controller-generator.dart';

class TrackOrder extends StatefulWidget {
  String orderId;
  String productId;
  TrackOrder(this.orderId, this.productId, {super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  late OrderController orderController;

  List<TrackerData> orderPlaced = [];

  List<TrackerDetails> orderPreTransitDetails = [];
  List<TrackerDetails> orderTransitDetails = [];
  List<TrackerDetails> orderDeliveredDetails = [];

  @override
  void initState() {
    orderController =
        ControllerGenerator.create(OrderController(), tag: widget.orderId);
    orderController.setOrderId(widget.orderId);

    if(orderController.initialized){
      if(orderController.shippingDhl.value.shipments != null){

        for(Shipment sp in orderController.shippingDhl.value.shipments!){

          if(sp.events!.isNotEmpty){

            for(Event ev in sp.events!){

              if(ev.statusCode!.toLowerCase() == "pre-transit".toLowerCase()){
                orderPreTransitDetails.add(TrackerDetails(title: ev.description! +"\n${ev.location!.address!.addressLocality}" ?? '', datetime: ev.timestamp ?? ''));
              }else if(ev.statusCode!.toLowerCase() == "transit".toLowerCase()){
                orderTransitDetails.add(TrackerDetails(title: ev.description! +"\n${ev.location!.address!.addressLocality}" ?? '', datetime: ev.timestamp ?? ''));
              }else if(ev.statusCode!.toLowerCase() == "delivered".toLowerCase()){
                orderDeliveredDetails.add(TrackerDetails(title: ev.description! +"\n${ev.location!.address!.addressLocality}" ?? '', datetime: ev.timestamp ?? ''));
              }


            }


          }
          if(sp.id == widget.productId){}

        }

        orderPlaced.add(TrackerData(title: "Order Placed", date: "", tracker_details: orderPreTransitDetails));
        orderPlaced.add(TrackerData(title: "Order Shipped", date: "", tracker_details: orderTransitDetails));
        orderPlaced.add(TrackerData(title: "Order Delivered", date: "", tracker_details: orderDeliveredDetails));

        setState(() {

        });

      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
       elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: OrderTrackerZen(
            tracker_data: orderPlaced,
          )
        ),
      ),
    );
  }
}
