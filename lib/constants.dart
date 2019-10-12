import 'package:flutter/rendering.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/job_posting.dart';

import 'common/book_sitter_tile_widget.dart';

const String about =
    'It shouldn’t be difficult to find capable, reliable and trustworthy childcare. That\'s what I said when I started Nanny McTea Sitters. Drawing on my own personal nanny experiences as well the other experiences of professional nannies within our team, we established a full child care agency that ensures rigorous screening and customized matching. With years of collective experience in childcare, We\'ve learned what families want and are proud to share this with you.';

const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/nanny-mctea-sitters.appspot.com/o/Images%2FUsers%2FDummy%2Fprofile.jpg?alt=media&token=2dff3e32-0140-4adc-9c33-81366ec8a322';

const String COMPANY_EMAIL = 'nannymctea@gmail.com';
const String COMPANY_PHONE = '(859)905-0174';

const List<String> ADMIN_UIDS = ['KFO2MAjsJNP1racr4Uivs8Zz3h32'];

const String STRIPE_GOLD_PLAN_ID = 'plan_FvwSxZO4qQOoZR';

const List<String> MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

JobPosting JP_FULL_TIME = JobPosting(
    title: 'Full Time Nanny',
    url:
        'https://docs.google.com/forms/d/e/1FAIpQLScLt5e0c-tGlMdFw9ALAMuDpYKKgKs0W_1DGVnxhZ351gDbwA/viewform?usp=sf_link',
    description:
        'Hyde Park family seeks part time nanny for a long term contract with 4 year old girl. Hours Include: -Monday - Friday 6:30 am - 8:30 am . -Monday - Wednesday 3 pm - 5:30 pm  -Thursday & Friday 11 am - 4:30 pm  Some household chores are expected such as loading and unloading dishwasher. Child\'s laundry.  Family is seeking a reliable, experienced and enthusiastic individual. Pay starts at \$15/hr and is based on education and experience.',
    posted: DateTime.now(),
    imgUrl:
        'https://firebasestorage.googleapis.com/v0/b/nanny-mctea-sitters.appspot.com/o/Images%2FJobs%2Fpart_time_nanny.jpg?alt=media&token=4d1ee2da-65b6-4403-bb50-18a7bfa23372');
