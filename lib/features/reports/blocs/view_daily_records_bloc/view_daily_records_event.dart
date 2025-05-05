part of 'view_daily_records_bloc.dart';

@immutable
sealed class ViewDailyRecordsEvent {}

final class LoadRecordsEvent extends ViewDailyRecordsEvent {
  final DateTime date;
  LoadRecordsEvent(this.date);
}

class SearchDailyRecordsEvent extends ViewDailyRecordsEvent {
  final String query;
  SearchDailyRecordsEvent(this.query);

  @override
  List<Object> get props => [query];
}
