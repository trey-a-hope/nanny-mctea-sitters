import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BookSitterServiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChildCareServiceState extends BookSitterServiceState {
  final List<Map<String, dynamic>> services = [
    {
      'service': 'Last Minute or Sick Care | 4 hr \$15',
      'description':
          'Is your child sick or you\'re in need of a last minute care? NMS will be happy to assist you. *\$15 Booking Fee + nanny paid in person a \$17Hr Rate. *It is YOUR families responsibilities to pay your sitter \$17 per hour the day of your sitter service*',
      'hours': 4,
      'cost': 15.0
    },
    {
      'service': '4 Hour Sitter Service | 4 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 4,
      'cost': 5.0
    },
    {
      'service': '5 Hour Sitter Service | 5 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 5,
      'cost': 5.0
    },
    {
      'service': '6 Hour Sitter Service | 6 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 6,
      'cost': 5.0
    },
    {
      'service': '7 Hour Sitter Service | 7 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 7,
      'cost': 5.0
    },
    {
      'service': '8 Hour Sitter Service | 8 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 8,
      'cost': 5.0
    },
    {
      'service': '9 Hour Sitter Service | 9 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 9,
      'cost': 5.0
    },
    {
      'service': '10 Hour Sitter Service | 10 hr \$5',
      'description':
          'Do you need a night on the town, or just free time to make a grocery run, appointment etc, NMS is here to help! Book a pre- interviewed and background checked sitter today! *\$5 Booking Fee paid ONLINE. *It is YOUR families responsibility to pay your sitter \$13/hr the day of your service*. 4Hr \$52, 5Hr \$65, 6Hr \$78, 7Hr \$91, 8Hr \$104, 9Hr \$117, 10Hr \$130. Contact Us if needs exceed 10Hrs.',
      'hours': 10,
      'cost': 5.0
    },
  ];

  ChildCareServiceState();

  @override
  List<Object> get props => [services];
}

class FeesRegistrationState extends BookSitterServiceState {
  final List<Map<String, dynamic>> services = [
    {
      'service': 'Family Consultation | 2hr \$350',
      'description':
          'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.',
      'hours': 2,
      'cost': 350.0
    },
    {
      'service': 'Placement Fee | 1hr \$1,125',
      'description':
          'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.',
      'hours': 1,
      'cost': 1125.0
    },
    {
      'service': 'Rush Fee | 1hr \$200',
      'description':
          'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.',
      'hours': 1,
      'cost': 200.0
    },
    {
      'service': 'Last Minute Sitter Care | 1hr \$35',
      'description':
          'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.',
      'hours': 1,
      'cost': 35.0
    }
  ];

  FeesRegistrationState();

  @override
  List<Object> get props => [services];
}

class MonthlySitterMembershipState extends BookSitterServiceState {
  final List<Map<String, dynamic>> services = [
    {
      'service': 'Membership Booking | 3hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 3,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 4hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 4,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 5hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 5,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 6hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 6,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 7hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 7,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 8hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 8,
      'cost': 25.00
    },
    {
      'service': 'Membership Booking | 9hr Waived booking fee!',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 9,
      'cost': 25.00
    }
  ];

  MonthlySitterMembershipState();

  @override
  List<Object> get props => [services];
}

class NavigateToBookSitterCalendarState extends BookSitterServiceState {
  final int hours;
  final String service;
  final double cost;

  NavigateToBookSitterCalendarState({
    @required this.hours,
    @required this.service,
    @required this.cost,
  });

  @override
  List<Object> get props => [
        hours,
        service,
        cost,
      ];
}
