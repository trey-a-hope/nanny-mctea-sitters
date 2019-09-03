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

class Review {
  String review;
  String author;
  Review(review, author){
    this.review = review;
    this.author = author;
  }
}
final List<Review> reviews = [
  Review('I cannot say enough about Nanny McTea and the fantastic caregivers here! We have someone that we trust who loves our kiddo, takes care in planning fun activities, provides guidance for listening skills, and is available on date nights as well.', 'Morales Family'),
  Review('We loved Nanny McTea! We had just moved to the area and were in a pinch. She came prepared! She had felt books for my 1 year old and made slime with my 3.5 year old! I love how she focuses on learning and activities rather than screen time! That was only my 2nd time my kids have had a sitter other than family and and they loved her even my emotional 1 year old! Would recommend to anyone!', 'Cady  Family'),
  Review('Love how easy it is to book and set up a caregiver with set prices for a set time.  Very Easy to work with, great caregivers!', 'Eavenson Family'),
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