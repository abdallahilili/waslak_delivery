import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:ui' as ui;
import '../../models/place_model.dart';
import '../../controllers/places_controller.dart';
import 'package:geolocator/geolocator.dart';

class PlaceMapView extends StatefulWidget {
  final double lat;
  final double lng;
  final bool isReadOnly;
  final Function(LatLng)? onPositionChanged;
  final List<PlaceModel>? otherPlaces;
  final IconData? icon;

  const PlaceMapView({
    Key? key,
    required this.lat,
    required this.lng,
    this.isReadOnly = false,
    this.onPositionChanged,
    this.otherPlaces,
    this.icon,
  }) : super(key: key);

  @override
  State<PlaceMapView> createState() => _PlaceMapViewState();
}

class _PlaceMapViewState extends State<PlaceMapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor? _customPlaceIcon;
  Marker? _selectedMarker;
  final PlacesController controller = Get.find<PlacesController>();

  @override
  void initState() {
    super.initState();
    _initIcons();
    _updateMarker(LatLng(widget.lat, widget.lng));
  }

  @override
  void didUpdateWidget(PlaceMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _updateMarker(LatLng(widget.lat, widget.lng));
      _moveCamera(LatLng(widget.lat, widget.lng));
    }
  }

  Future<void> _initIcons() async {
    _customPlaceIcon = await _getMarkerIcon(
      widget.icon ?? Icons.delivery_dining, 
      const Color.fromARGB(255, 5, 88, 7), 
      90
    );
    if (mounted) setState(() {});
  }

  void _updateMarker(LatLng pos) {
    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId('selected_pos'),
        position: pos,
        icon: _customPlaceIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Position"),
      );
    });
  }

  Future<void> _moveCamera(LatLng pos) async {
    final GoogleMapController c = await _mapController.future;
    c.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    _moveCamera(latLng);
    if (!widget.isReadOnly && widget.onPositionChanged != null) {
      widget.onPositionChanged!(latLng);
    }
  }

  Future<BitmapDescriptor> _getMarkerIcon(IconData iconData, Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double radius = size / 2;
    final double pinHeight = size * 1.4;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final Path shadowPath = Path();
    shadowPath.addOval(Rect.fromLTWH(2, 2, size, size));
    canvas.drawPath(shadowPath, shadowPaint);

    final Paint paint = Paint()..color = color;
    final Path path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size, size));
    path.moveTo(size * 0.15, radius * 1.5);
    path.lineTo(radius, pinHeight);
    path.lineTo(size * 0.85, radius * 1.5);
    path.close();
    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(radius, radius), radius * 0.75, Paint()..color = Colors.white);

    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(fontSize: size * 0.55, fontFamily: iconData.fontFamily, color: color),
    );
    painter.layout();
    painter.paint(canvas, Offset(radius - painter.width / 2, radius - painter.height / 2));

    final ui.Image image = await pictureRecorder.endRecording().toImage((size + 4).toInt(), (pinHeight + 4).toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMap(),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              _MapButton(
                icon: _currentMapType == MapType.normal ? Icons.satellite : Icons.map,
                onPressed: _toggleMapType,
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.my_location,
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    final Set<Marker> markers = {};
    if (_selectedMarker != null) markers.add(_selectedMarker!);

    if (widget.otherPlaces != null) {
      for (var p in widget.otherPlaces!) {
        markers.add(Marker(
          markerId: MarkerId('other_${p.id}'),
          position: LatLng(p.latitude, p.longitude),
          icon: _customPlaceIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          alpha: 0.5,
          infoWindow: InfoWindow(title: p.nom),
        ));
      }
    }

    return GoogleMap(
      mapType: _currentMapType,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 15),
      onMapCreated: (c) => _mapController.complete(c),
      onTap: widget.isReadOnly
          ? null
          : (pos) {
              _updateMarker(pos);
              if (widget.onPositionChanged != null) widget.onPositionChanged!(pos);
            },
      markers: markers,
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
