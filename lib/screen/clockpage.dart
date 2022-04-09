import 'dart:convert';

import 'package:crmcc/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crmcc/data/clock_data.dart';
import 'package:crmcc/model/clock_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crmcc/constants/dio_intrepters.dart';
import 'package:crmcc/model/clock_data_model.dart';
import 'package:intl/intl.dart';

var errorText2 = " ";
bool errorLoading = false;

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);
  static const routeName = "clocking_page";
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  ClockingData? currentStatus;
  bool isLoading = false;
  @override
  void initState() {
    loadCurrentStatus();
    getLeaveHistory();
    super.initState();
  }

  Future<void> loadCurrentStatus() async {
    setState(() {
      isLoading = true;
    });
    final status = await ClockData().clockStatus(data!.user!.id);
    setState(() {
      currentStatus = status;
      isLoading = false;
    });
  }

  var list;

  bool loading = false;
  bool mainPage = true;
  bool leaveMgmt = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: !mainPage
          ? !leaveMgmt
              ? ListView(
                  children: [
                    leaveScreen(),
                  ],
                )
              : leaveHistoryScreen()
          : Container(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white)),
                color: Colors.black,
              ),
              child: Text("LABEL"),
            ),
            ListTile(
              title: const Text('Clock In'),
              onTap: () {
                setState(() {
                  mainPage = true;
                  loaded = false;
                  errorLoading = false;
                  endText = "End Date";
                  startText = "Start Date";
                  success = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Leave Request'),
              onTap: () {
                setState(() {
                  mainPage = false;
                  leaveMgmt = false;
                  loaded = false;
                  errorLoading = false;
                  endText = DateFormat("LLL dd, y").format(
                      DateTime.now().hour < 9
                          ? DateTime.now().add(Duration(days: 1))
                          : DateTime.now().add(Duration(days: 2)));
                  ;
                  startText = DateFormat("LLL dd, y").format(
                      DateTime.now().hour < 9
                          ? DateTime.now().add(Duration(days: 0))
                          : DateTime.now().add(Duration(days: 1)));
                  success = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Previous Leave Requests'),
              onTap: () {
                setState(() {
                  mainPage = false;
                  leaveMgmt = true;
                  endText = DateFormat("LLL dd, y").format(
                      DateTime.now().hour < 9
                          ? DateTime.now().add(Duration(days: 1))
                          : DateTime.now().add(Duration(days: 2)));
                  ;
                  startText = DateFormat("LLL dd, y").format(
                      DateTime.now().hour < 9
                          ? DateTime.now().add(Duration(days: 0))
                          : DateTime.now().add(Duration(days: 1)));
                  ;
                  success = true;
                });
                getLeaveHistory();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool success = false;

  bool loadingRequest = false;

  var startText = DateFormat("LLL dd, y").format(DateTime.now().hour < 9
      ? DateTime.now().add(Duration(days: 0))
      : DateTime.now().add(Duration(days: 1)));
  var endText = DateFormat("LLL dd, y").format(DateTime.now().hour < 9
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now().add(Duration(days: 2)));

  bool loaded = false;

  Widget leaveHistoryScreen() {
    return ListView(
      children: [
        !loaded
            ? Container()
            : errorLoading
                ? historyRecord()
                : historyRecord()
      ],
    );
  }

  Widget historyRecord() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Leave History',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30))),
        for (var i in list.reversed)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 125,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(41, 42, 51, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Container(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  'Start Date: ' +
                                      DateFormat("LLL dd-y").format(
                                          DateTime.parse(i['start_date'])),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Container(
                            child: Text(
                                'End Date: ' +
                                    DateFormat("LLL dd-y")
                                        .format(DateTime.parse(i['end_date'])),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Container(
                            child:
                                Text('Request Status: ' + i['request_status'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: i['request_status'] == "Pending"
                                            ? Colors.orange
                                            : i['request_status'] == "Approved"
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Container(
                            child: Text(
                                'Date Requested: ' +
                                    DateFormat("LLL dd-y  hh:mm").format(
                                        (DateTime.parse(i['created_at']))
                                            .toLocal()),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Container(
                            child: Text('Reason: ' + i['reason'],
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool endDateSet = false;
  DateTime? endDate;
  DateTime? startDate;

  getLeaveHistory() async {
    setState(() {
      loaded = false;
      errorLoading = false;
    });
    try {
      final rs = (await api().get("/leave/myLeaves",
              queryParameters: {'user_id': data!.user!.id}))
          .data;
      list = rs['response'];

      if (list == null) {
        setState(() {
          errorLoading = true;
        });
      }
    } catch (e) {
      setState(() {
        errorLoading = true;
      });
    } finally {
      setState(() {
        loaded = true;
      });
    }
  }

  Widget leaveScreen() {
    TextEditingController reasonCtlr = TextEditingController();
    TextEditingController notesCtlr = TextEditingController();

    return Column(
      children: [
        ElevatedButton.icon(
            onPressed: () async {
              startDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().hour < 9
                      ? DateTime.now()
                      : DateTime.now().add(Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90000)));

              setState(() {
                startText =
                    DateFormat("LLL dd, y").format(startDate as DateTime);
              });
            },
            icon: Icon(Icons.date_range),
            label: Text(startText)),
        ElevatedButton.icon(
            onPressed: () async {
              endDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().hour < 9
                      ? DateTime.now().add(Duration(days: 1))
                      : DateTime.now().add(Duration(days: 2)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90000)));

              setState(() {
                endText = DateFormat("LLL dd, y").format(endDate as DateTime);
              });
            },
            icon: Icon(Icons.date_range),
            label: Text(endText)),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            autocorrect: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Reason",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: reasonCtlr,
          ),
        ),
        loadingRequest
            ? Padding(
                padding: EdgeInsets.all(10), child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      print(endDate);
                      print(startDate.toString() + "Start");
                      setState(() {
                        loadingRequest = true;
                      });
                      try {
                        await createLeave(
                            data!.user!.id,
                            startDate as DateTime,
                            endDate as DateTime,
                            endDate!.difference(startDate as DateTime).inDays,
                            reasonCtlr.text);
                      } catch (e) {
                        errorText2 = e.toString();
                      } finally {
                        setState(() {
                          loadingRequest = false;
                        });
                      }
                    },
                    icon: Icon(Icons.check),
                    label: Text("Submit Request"))),
        success
            ? loadingRequest
                ? Container()
                : Text("REQUEST CREATED SUCCESFULLY!",
                    style: TextStyle(color: Colors.green))
            : loadingRequest
                ? Container()
                : Text(errorText2, style: TextStyle(color: Colors.red)),
      ],
    );
  }

  changeStatus() async {
    print(currentStatus?.status);
    setState(() {
      loading = true;
    });
    try {
      if (currentStatus?.status == null) {
        await ClockData().clockIn(data!.user!.id);
      } else if (currentStatus?.status == ClockType.clockIn) {
        await ClockData().clockOut(currentStatus!.id);
      }
      await loadCurrentStatus();
    } catch (e) {
      await loadCurrentStatus();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  refreshDateTexts() {
    setState(() {
      endText = endText;
      startText = startText;
    });
  }

  Future createLeave(int userId, DateTime startDate, DateTime endDate,
      int numDays, String reason) async {
    final rs = (await api().post(
      "/leave/createLeave",
      data: {
        'user_id': userId,
        'start_date': DateFormat("yyyy-MM-dd hh:mm").format(startDate),
        'end_date': DateFormat("yyyy-MM-dd hh:mm").format(endDate),
        'days_needed': numDays,
        'reason': reason,
        'notes': "not required.",
      },
    ))
        .data;

    if (rs['message'] == "Leave record created successfully.") {
      success = true;
    } else {
      success = false;
    }

    refreshSuccess();
  }

  refreshSuccess() {
    setState(() {
      success = success;
    });
  }
}
