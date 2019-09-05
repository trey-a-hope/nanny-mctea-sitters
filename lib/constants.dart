import 'package:flutter/rendering.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';

import 'common/book_sitter_tile_widget.dart';

const String about =
    'It shouldn’t be difficult to find capable, reliable and trustworthy childcare. That\'s what I said when I started Nanny McTea Sitters. Drawing on my own personal nanny experiences as well the other experiences of professional nannies within our team, we established a full child care agency that ensures rigorous screening and customized matching. With years of collective experience in childcare, We\'ve learned what families want and are proud to share this with you.';

const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/nanny-mctea-sitters.appspot.com/o/Images%2FUsers%2FDummy%2Fprofile.jpg?alt=media&token=2dff3e32-0140-4adc-9c33-81366ec8a322';

final List<AssetImage> images = [
  group_nannies,
  group_nannies
];

final List<Sitter> sitters = [
  Sitter(
    'Talea Chenault',
    'CEO & Owner',
    AssetImage('assets/images/talea_chenault.jpg'),
  ),
  Sitter(
    'Mariah Johnson',
    'COO & Consultant',
    AssetImage('assets/images/mariah_johnson.jpg'),
  ),
  Sitter(
    'Tkeyah James',
    'COO & Consultant',
    AssetImage('assets/images/tkeyah_james.jpg'),
  ),
  Sitter(
    'Deaira Mitchell',
    'Sitter',
    AssetImage('assets/images/deaira_mitchell.jpg'),
  ),
  Sitter(
    'Jibril McCaster',
    'Sitter',
    AssetImage('assets/images/jibril_mccaster.jpg'),
  ),
    Sitter(
    'Tamara Samedy',
    'Sitter',
    AssetImage('assets/images/tamara_samedy.jpg'),
  )
];