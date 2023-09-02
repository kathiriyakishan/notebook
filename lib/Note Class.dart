import 'package:hive/hive.dart';

part 'Note Class.g.dart';

@HiveType(typeId: 0)
class note extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String subtitle;
  @HiveField(2)
  String date;

  note(this.title, this.subtitle, this.date);

  @override
  String toString() {
    return 'note{title: $title, subtitle: $subtitle, date: $date}';
  }
}
