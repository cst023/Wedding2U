import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_dashboard.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_dashboard2.dart';
import 'package:wedding2u_app/presentation/screens/client/client_edit_profile.dart';
import 'package:wedding2u_app/presentation/screens/client/client_post.dart';
import 'package:wedding2u_app/presentation/screens/client/countdown.dart';
import 'package:wedding2u_app/presentation/screens/client/guests_page.dart';
import 'package:wedding2u_app/presentation/screens/client/manage_wedding.dart';
import 'package:wedding2u_app/presentation/screens/general/sign_in_page.dart';
import 'package:wedding2u_app/presentation/screens/general/continue_guest_page.dart';
import 'package:wedding2u_app/presentation/screens/client/client_main_page.dart';
import 'package:wedding2u_app/presentation/screens/client/client_profile_page.dart';
import 'package:wedding2u_app/presentation/screens/client/vendor_catalog.dart';
import 'package:wedding2u_app/presentation/screens/client/photographers.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_dashboard.dart';
import 'package:wedding2u_app/presentation/screens/client/tentative_page.dart';
import 'package:wedding2u_app/presentation/screens/client/venue_booking_status.dart';
import 'package:wedding2u_app/presentation/screens/client/venue_catalog.dart';
import 'package:wedding2u_app/presentation/screens/general/sign_up_user_roles.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'SignIn': (context) => SignIn(),
  'SignUpUserRoles': (context) => SignUpUserRoles(),
  'ContinueGuest': (context) => ContinueGuest(),
  'ClientMainPage': (context) => ClientMainPage(),
  'ClientProfilePage': (context) => ClientProfilePage(),
  'ClientEditProfile': (context) => ClientEditProfile(),
  'ManageWedding': (context) => ManageWedding(),
  'TentativePage': (context) => TentativePage(),
  'GuestsPage': (context) => GuestsPage(),
  'CountdownPage': (context) => CountdownPage(),
  'VenueCatalog': (context) => VenueCatalog(),
  'WeddingPosts': (context) => WeddingPosts(),
  'VenueBookingStatus': (context) => VenueBookingStatus(),
  'VendorCatalog': (context) => VendorCatalog(),
  'PhotographersPage': (context) => PhotographersPage(),
  'VendorDashboard': (context) => VendorDashboard(),
  'AdminDashboard': (context) => AdminDashboard(),
  'AdminDashboard2': (context) => AdminDashboard2(),
};
