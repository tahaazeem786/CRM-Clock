import 'package:crmcc/model/user_data_model.dart';

enum ClockType { clockIn, clockOut }

class ClockingData {
  late int id;
  late String userId;
  late String clockDate;
  late String clockMethod;
  String? clockIn;
  String? clockOut;
  late String createdAt;
  late String updatedAt;
  User? user;
  ClockType? status;
  ClockingData(
      {required this.id,
      required this.userId,
      required this.clockDate,
      required this.clockMethod,
      this.clockIn,
      this.clockOut,
      required this.createdAt,
      required this.updatedAt,
      this.user});

  ClockingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clockDate = json['clock_date'];
    clockMethod = json['clock_method'];
    clockIn = json['clock_in'];
    clockOut = json['clock_out'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (clockIn != null && clockOut != "0000-00-00 00:00:00") {
      status = ClockType.clockOut;
    } else if (clockIn != null && clockOut == "0000-00-00 00:00:00") {
      status = ClockType.clockIn;
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['clock_date'] = clockDate;
    data['clock_method'] = clockMethod;
    data['clock_in'] = clockIn;
    data['clock_out'] = clockOut;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user?.toJson();
    }

    return data;
  }
}
