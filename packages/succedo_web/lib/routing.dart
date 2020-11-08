import 'package:flutter/material.dart';
import 'package:succedo_web/agenda/agenda_page.dart';
import 'package:succedo_web/backlog/backlog_page.dart';
import 'package:succedo_web/calendar/calendar_page.dart';
import 'package:succedo_web/reminders/reminders_page.dart';

class RouteGenerator {
  static const String homePage = "/";
  static const String agendaPage = "/agenda";
  static const String backlogPage = "/backlog";
  static const String calendarPage = "/calendar";
  static const String remindersPage = "/reminders";

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
      case agendaPage:
        return _CustomPageRoute(
          builder: (_) => const AgendaPage(),
        );
      case backlogPage:
        return _CustomPageRoute(
          builder: (_) => const BacklogPage(),
        );
      case calendarPage:
        return _CustomPageRoute(
          builder: (_) => const CalendarPage(),
        );
      case remindersPage:
        return _CustomPageRoute(
          builder: (_) => const RemindersPage(),
        );
      default:
        throw _RouteException("Route not found");
    }
  }
}

class _CustomPageRoute extends MaterialPageRoute {
  _CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _RouteException implements Exception {
  final String message;

  _RouteException(this.message);
}
