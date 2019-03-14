import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'place.dart';

class StubData {
  static const List<Place> places = [
    Place(
      id: '1',
      latLng: LatLng(60.197686, 24.903729),
      name: 'Cereal factory',
      description:
          'We make the best cereals in the world but we polute a lot!',
      category: PlaceCategory.factory,
      starRating: 4,
    ),
    Place(
      id: '2',
      latLng: LatLng(60.1820997, 24.9304026),
      name: 'Cement production facility CO',
      description:
          'We do it!',
      category: PlaceCategory.factory,
      starRating: 3,
    ),
    Place(
      id: '3',
      latLng: LatLng(60.169921, 24.9504155),
      name: 'New shopping mall',
      description:
          'We build a better future for your shopping!',
      category: PlaceCategory.construction,
      starRating: 5,
    ),
    Place(
      id: '4',
      latLng: LatLng(60.1617064, 24.9316488),
      name: 'Your best new amusement park!',
      description:
          'You will have so much fun in our new park!',
      category: PlaceCategory.construction,
      starRating: 4,
    ),
  ];

  static const List<String> reviewStrings = [
    'My favorite place! The employees are wonderful and so is the food. I go here at least once a month!',
    'Staff was very friendly. Great atmosphere and good music. Would reccommend.',
    'Best. Place. In. Town. Period.'
  ];
}
