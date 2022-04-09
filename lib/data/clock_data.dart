import 'package:crmcc/constants/dio_intrepters.dart';
import 'package:crmcc/model/clock_data_model.dart';
import 'package:intl/intl.dart';

class ClockData {
  Future clockIn(int userId) async {
    return (await api().post(
      "user/clockTimes/createClockIn",
      data: {
        'user_id': userId,
        'clock_date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
        'clock_method': 'Mobile',
        'clock_in': DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now())
      },
    ))
        .data;
  }

  Future clockOut(int clockInId) async {
    final rs = (await api().post(
      "user/clockTimes/createClockOut",
      data: {
        'id': clockInId,
        'clock_out': DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now()),
      },
    ))
        .data;
    print(rs.toString() + "CHECK HERE CLOWN");
  }

  Future<ClockingData?> clockStatus(int userId) async {
    final res = (await api()
            .get("user/clockTimes/getStatus", queryParameters: {'id': userId}))
        .data;
    if (res['success'] == true) {
      return ClockingData.fromJson(res['data'] as Map<String, dynamic>);
    }
  }

  Future createLeave(int userId, DateTime startDate, DateTime endDate, int numDays, String notes, String reason) async {
    final rs = (await api().post(
      "user/leave/create",
      data: {
        'user_id': userId,
        'start_date': DateFormat("yyyy-MM-dd hh:mm").format(startDate),
        'end_date': DateFormat("yyyy-MM-dd hh:mm").format(endDate),
        'days_needed': numDays,
        'reason': reason,
        'notes': notes,
      },
    ))
        .data;
    print(rs.toString() + "CHECK HERE CLOWN");
  }
}
