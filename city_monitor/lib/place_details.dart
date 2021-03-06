import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'place.dart';
import 'stub_data.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({
    @required this.place,
    @required this.onChanged,
    Key key,
  })  : assert(place != null),
        assert(onChanged != null),
        super(key: key);

  final Place place;
  final ValueChanged<Place> onChanged;

  @override
  PlaceDetailsState createState() => PlaceDetailsState();
}

class PlaceDetailsState extends State<PlaceDetails> {
  Place _place;
  GoogleMapController _mapController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _place = widget.place;
    _nameController.text = _place.name;
    _descriptionController.text = _place.description;
    return super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.addMarker(MarkerOptions(position: _place.latLng));
  }

  Widget _detailsBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
      children: <Widget>[
        _NameTextField(
          controller: _nameController,
          onChanged: (String value) {
            setState(() {
              _place = _place.copyWith(name: value);
            });
          },
        ),
        _DescriptionTextField(
          controller: _descriptionController,
          onChanged: (String value) {
            setState(() {
              _place = _place.copyWith(description: value);
            });
          },
        ),
        _StarBar(
          rating: _place.starRating,
          onChanged: (int value) {
            setState(() {
              _place = _place.copyWith(starRating: value);
            });
          },
        ),
        _Map(
          center: _place.latLng,
          mapController: _mapController,
          onMapCreated: _onMapCreated,
        ),
        _Report(
          place: _place,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_place.name}'),
        backgroundColor: Colors.green[700],
        /*actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
            child: IconButton(
              icon: const Icon(Icons.save, size: 30.0),
              onPressed: () {
                widget.onChanged(_place);
                Navigator.pop(context);
              },
            ),
          ),
        ],*/
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _detailsBody(),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(fontSize: 18.0),
        ),
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        autocorrect: true,
        controller: controller,
        enabled: false,
        onChanged: (String value) {
          onChanged(value);
        },
      ),
    );
  }
}

class _DescriptionTextField extends StatelessWidget {
  const _DescriptionTextField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(fontSize: 18.0),
        ),
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        maxLines: null,
        autocorrect: true,
        controller: controller,
        onChanged: (String value) {
          onChanged(value);
        },
        enabled: false,
      ),
    );
  }
}

class _StarBar extends StatelessWidget {
  const _StarBar({
    @required this.rating,
    @required this.onChanged,
    Key key,
  })  : assert(rating != null && rating >= 0 && rating <= maxStars),
        assert(onChanged != null),
        super(key: key);

  static const int maxStars = 5;
  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxStars, (int index) {
        return IconButton(
          icon: const Icon(Icons.star),
          iconSize: 40.0,
          color: rating > index ? Colors.amber : Colors.grey[400],
          onPressed: () {
            onChanged(index + 1);
          },
        );
      }).toList(),
    );
  }
}

class _Map extends StatelessWidget {
  const _Map({
    @required this.center,
    @required this.mapController,
    @required this.onMapCreated,
    Key key,
  })  : assert(center != null),
        assert(onMapCreated != null),
        super(key: key);

  final LatLng center;
  final GoogleMapController mapController;
  final ArgumentCallback<GoogleMapController> onMapCreated;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4.0,
      child: SizedBox(
        width: 340.0,
        height: 240.0,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          options: GoogleMapOptions(
            cameraPosition: CameraPosition(
              target: center,
              zoom: 16.0,
            ),
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            scrollGesturesEnabled: false,
          ),
        ),
      ),
    );
  }
}

class _Report extends StatefulWidget {
  final Place place;

  const _Report({
    @required this.place,
    Key key,
  }) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<_Report> {
  List<String> _locations = ['Air', 'Noise'];

  TextEditingController _descriptionController = TextEditingController();

  String reason = "";
  String description = "";
  int _sliderValue = 1;

  @override
  void initState() {
    reason = _locations[0];
    _descriptionController.text = "";
    return super.initState();
  }

  Future submit() async {
    var currentLocation = <String, double>{};

    var location = new Location();

    currentLocation = await location.getLocation();

    debugPrint("USER COORDS " +
        currentLocation["latitude"].toString() +
        "|" +
        currentLocation["longitude"].toString());

    var url =
        "http://json.devices.digitalenabler.eng.it:8096/iot/d?i=user_app&k=IaOHpBJp4ITSehW";

    var data = {
      "lat": widget.place.latitude.toString(),
      "long": widget.place.longitude.toString(),
      "place_id": widget.place.id,
      "description": description,
      "alert": reason,
      "date": DateTime.now().toIso8601String(),
      "intensity": _sliderValue,
      "location": currentLocation["latitude"].toString() + "," + currentLocation["longitude"].toString(),
    };

    debugPrint(data.toString());

    var body = json.encode(data);

    http
        .post(url, headers: {"Content-Type": "application/json"}, body: body)
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Data sent! Thank you!')));
      _descriptionController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 16.0),
          child: Text(
            'Any problems to report?',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          )),
      DropdownButton(
        hint: Text('Please choose a reason'), // Not necessary for Option 1
        value: reason,
        onChanged: (newValue) {
          setState(() {
            reason = newValue;
          });
        },
        items: _locations.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 16.0),
          child: Text(
            'How bad is the problem?',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Slider(
              activeColor: Colors.indigoAccent,
              min: 1,
              max: 10,
              onChanged: (newRating) {
                setState(() => _sliderValue = newRating.toInt());
              },
              value: _sliderValue.toDouble(),
            ),
          ),

          // This is the part that displays the value of the slider.
          Container(
            width: 50.0,
            alignment: Alignment.center,
            child: Text('${_sliderValue.toInt()}',
                style: Theme.of(context).textTheme.display1),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 16.0),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(fontSize: 18.0),
          ),
          style: const TextStyle(fontSize: 20.0, color: Colors.black87),
          maxLines: null,
          autocorrect: true,
          controller: _descriptionController,
          onChanged: (String value) {
            description = value;
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            submit();
          },
          child: Text('Submit'),
        ),
      ),
    ]);
  }
}
