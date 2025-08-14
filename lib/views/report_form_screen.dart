import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart';
import '../models/report.dart';

class ReportFormScreen extends StatefulWidget {
  final Function(Report)? onSubmit;

  const ReportFormScreen({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String? _receiptImagePath;
  String _startPoint = 'Not selected';
  String _endPoint = 'Not selected';
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  String _category = 'General';
  final List<String> _categories = [
    'General',
    'Transport',
    'Food',
    'Accommodation',
    'Other'
  ];

  final ImagePicker _picker = ImagePicker();
  final location_package.Location _location = location_package.Location();

  Future<void> _pickReceiptImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _receiptImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectOnMap(bool isStartPoint) async {
    try {
      // Check and request location services
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled')),
          );
          return;
        }
      }

      // Check and request location permissions
      var permissionStatus = await _location.hasPermission();
      if (permissionStatus == location_package.PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != location_package.PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
          return;
        }
      }

      // Get current location for initial camera position
      final locData = await _location.getLocation();
      final initialPosition = LatLng(locData.latitude!, locData.longitude!);

      // Open map picker
      final LatLng? selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapPickerScreen(
            initialPosition: initialPosition,
          ),
        ),
      );

      if (selectedLocation != null) {
        // Get address for selected location
        List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.latitude,
          selectedLocation.longitude,
        );

        String address = 'Unknown location';
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = [
            if (place.street != null) place.street,
            if (place.locality != null) place.locality,
            if (place.postalCode != null) place.postalCode,
            if (place.country != null) place.country,
          ].where((part) => part != null).join(', ');
        }

        setState(() {
          if (isStartPoint) {
            _startLatLng = selectedLocation;
            _startPoint = address;
          } else {
            _endLatLng = selectedLocation;
            _endPoint = address;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting location: ${e.toString()}')),
      );
      debugPrint('Location selection error: $e');
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_startLatLng == null || _endLatLng == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select both start and end points')),
        );
        return;
      }

      final newReport = Report(
        title: _title,
        description: _description,
        startPoint: _startPoint,
        endPoint: _endPoint,
        receiptImagePath: _receiptImagePath,
        date: DateTime.now(),
        category: _category,
        startLatLng: _startLatLng,
        endLatLng: _endLatLng,
      );

      widget.onSubmit?.call(newReport);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Report Title"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a title" : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a description" : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: _categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: "Category"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.map),
                        label: Text(_startPoint),
                        onPressed: () => _selectOnMap(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.flag),
                        label: Text(_endPoint),
                        onPressed: () => _selectOnMap(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_startLatLng != null && _endLatLng != null)
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _startLatLng!,
                        zoom: 12,
                      ),
                      markers: {
                        if (_startLatLng != null)
                          Marker(
                            markerId: const MarkerId('start'),
                            position: _startLatLng!,
                            infoWindow:
                                InfoWindow(title: 'Start: $_startPoint'),
                          ),
                        if (_endLatLng != null)
                          Marker(
                            markerId: const MarkerId('end'),
                            position: _endLatLng!,
                            infoWindow: InfoWindow(title: 'End: $_endPoint'),
                          ),
                      },
                      polylines: {
                        if (_startLatLng != null && _endLatLng != null)
                          Polyline(
                            polylineId: const PolylineId('route'),
                            points: [_startLatLng!, _endLatLng!],
                            color: Colors.blue,
                            width: 3,
                          ),
                      },
                      onTap: (LatLng location) {
                        // You can add tap-to-add functionality here if needed
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Attach Receipt Photo"),
                  onPressed: _pickReceiptImage,
                ),
                if (_receiptImagePath != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(_receiptImagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 100),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text("Submit Report"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapPickerScreen({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedLocation == null
                ? null
                : () => Navigator.of(context).pop(_selectedLocation),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 14,
        ),
        onTap: (LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        markers: _selectedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedLocation!,
                ),
              },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
