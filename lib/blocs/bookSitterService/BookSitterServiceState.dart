import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BookSitterServiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChildCareServiceState extends BookSitterServiceState {
  final List<Map<String, dynamic>> services = [
    {
      'service': '4 Hour Sitter Service | 4 hr \$77',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 4,
      'cost': 77.0
    },
    {
      'service': '5 Hour Sitter Service | 5 hr \$90',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 5,
      'cost': 90.0
    },
    {
      'service': '6 Hour Sitter Service | 6 hr \$103',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 6,
      'cost': 103.0
    },
    {
      'service': '7 Hour Sitter Service | 7 hr \$116',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 7,
      'cost': 116.0
    },
    {
      'service': '8 Hour Sitter Service | 8 hr \$129',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 8,
      'cost': 129.0
    },
    {
      'service': '9 Hour Sitter Service | 9 hr \$142',
      'description':
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.',
      'hours': 9,
      'cost': 142.0
    }
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
