import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/TV/provider/tv_provider.dart';
import 'package:smart_home/Screen/lightScreen/provider/lightProvider.dart';
import 'package:smart_home/Screen/notification/notification_provider.dart';
import 'package:smart_home/Screen/temperature/provider/fan_provider.dart';
import 'package:smart_home/models/Global.dart';
import 'package:smart_home/models/notification.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notificaion";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<MyNotification> notifications = [];
  Future<void> get_notification() async {
    print('object');
    try {
      FetchResult<List<MyNotification>> result = await fetechnotification();

      if (result.error != null) {
        // Handle the error if one occurred during fetching data
        print('111111111111111111111111111111111111111111111: ${result.error}');
      } else {
        // Data fetching was successful, use 'result.data'
        setState(() {
          final notificationProvider = Provider.of<NotificationProvider>(
            context,
            listen: false,
          );
          try {
            result.data!.sort((a, b) =>
                DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
            notificationProvider.setNotifications(result.data!);
          } catch (e) {
            print(e);
          }
        });
        // Use 'enfants' list here or update the UI with fetched data
      }
    } catch (error) {
      // Handle other exceptions that might occur during the process
      print('Exception occurred: $error');
    }
  }

  @override
  void initState() {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    if (notificationProvider.notificationsItems.length == 0) {
      get_notification();
    }

    super.initState();
  }

  Future<bool> setNotificationRead(String notificationId) async {
    var url = Uri.http(
        Global.ipadressnohttp, '/set_notification_read/' + notificationId);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to mark notification as read. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  Future<bool> setAnnoucmentRead(String notificationId) async {
    var url = Uri.http(Global.ipadressnohttp,
        '/set_Annoucment_read/' + notificationId + '/' + Global.id);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to mark notification as read. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  Future<bool> answerPrediction(String notificationId, String itemControled,
      String classPredicted, bool answer) async {
    var url = Uri.http(Global.ipadressnohttp,
        'answer_predict/${notificationId}/${itemControled}/${classPredicted}/${answer}/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to answer notification as ML. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    GlobalKey<State> _dialogKey = GlobalKey<State>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notificationProvider.notificationsItems.length == 0
          ? Center(
              child: Image.asset(
                "assets/images/nonotification.png",
                height: 200,
              ),
            )
          : AnimationLimiter(
              child: ListView.builder(
                itemCount: notificationProvider.notificationsItems.length,
                // Change this to the number of notifications you want to show
                itemBuilder: (context, index) {
                  var notification =
                      notificationProvider.notificationsItems[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: NotificationCard(
                          notification: notification,
                          onTap: () async {
                            if (notification.type == 'Notification') {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    key: _dialogKey,
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              try {
                                final result =
                                    await setNotificationRead(notification.id);

                                if (_dialogKey.currentContext != null) {
                                  Navigator.of(_dialogKey.currentContext!)
                                      .pop();
                                }
                                print(result);
                                if (result) {
                                  setState(() {
                                    notificationProvider
                                        .removeNotification(notification);
                                    // newNotification = List.from(
                                    //     newNotification); // Create a copy
                                    // newNotification.removeAt(index);
                                    // Global.notifications.removeWhere(
                                    //     (notification) =>
                                    //         notification.id == notification.id);
                                  });
                                } else {
                                  print('error');
                                }
                              } catch (e) {
                                // Handle the error
                                print('Error: $e');
                              }
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    key: _dialogKey,
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              try {
                                final result =
                                    await setAnnoucmentRead(notification.id);

                                if (_dialogKey.currentContext != null) {
                                  Navigator.of(_dialogKey.currentContext!)
                                      .pop();
                                }
                                print(result);
                                if (result) {
                                  setState(() {
                                    notificationProvider
                                        .removeNotification(notification);
                                  });
                                } else {
                                  print('error');
                                }
                              } catch (e) {
                                // Handle the error
                                print('Error: $e');
                              }
                            }

                            print('I\'m Trying ');
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final MyNotification notification;
  final VoidCallback onTap;

  NotificationCard({
    required this.notification,
    required this.onTap,
  });
  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 10) {
      return 'Just now';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Today
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (dateTime.year == now.year) {
      // This year
      return '${_getMonthName(dateTime.month)} ${dateTime.day}';
    } else {
      // Another year
      return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<State> _dialogKey = GlobalKey<State>();
    Future<bool> answerPrediction(String notificationId, String itemControled,
        String classPredicted, bool answer) async {
      var url = Uri.http(
          Global.ipadressnohttp, 'answer_predict/${notificationId}/${answer}/');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          return true;
        } else {
          print(
              'Failed to answer notification as ML. Status code: ${response.statusCode}');
          return false;
        }
      } catch (error) {
        print('Error: $error');
      }
      return false;
    }

    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    final lightProvider = Provider.of<LightProvider>(
      context,
      listen: false,
    );
    final fanProvider = Provider.of<FanProvider>(
      context,
      listen: false,
    );
    final tvProvider = Provider.of<TvProvider>(
      context,
      listen: false,
    );
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                leading: Icon(
                  notification.type == 'Notification'
                      ? FontAwesomeIcons.envelope
                      : notification.type == 'ML'
                          ? FontAwesomeIcons.microchip
                          : FontAwesomeIcons
                              .bullhorn, // Use any FontAwesomeIcons you prefer
                  color: Colors.blueAccent,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formatDateTime(notification.date).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.detail),
                    notification.type == 'ML'
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 50,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print(notification.id);
                                      print(notification.itemControlled);
                                      print(notification.predectedClass);
                                      // Handle YES button press
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Center(
                                            key: _dialogKey,
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      try {
                                        final result = await answerPrediction(
                                            notification.id,
                                            notification.itemControlled!,
                                            notification.predectedClass!,
                                            true);

                                        if (_dialogKey.currentContext != null) {
                                          Navigator.of(
                                                  _dialogKey.currentContext!)
                                              .pop();
                                        }
                                        print(result);
                                        if (result) {
                                          if (notification.itemControlled ==
                                              'light') {
                                            if (notification.predectedClass ==
                                                "0") {
                                              lightProvider.initLight(false);
                                            } else {
                                              lightProvider.initLight(true);
                                            }
                                          } else if (notification
                                                  .itemControlled ==
                                              'weather') {
                                            fanProvider.setFanLevel(int.parse(
                                                notification.predectedClass!));
                                          } else {
                                            tvProvider.setTVChannel(int.parse(
                                                notification.predectedClass!));
                                          }
                                          // notificationProvider
                                          //     .removeNotification(notification);
                                        } else {
                                          print('error');
                                        }
                                      } catch (e) {
                                        // Handle the error
                                        print('Error: $e');
                                      }
                                      notificationProvider
                                          .removeNotification(notification);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Colors.blueAccent, // Background color
                                      onPrimary: Colors.white, // Text color
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'YES',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print(notification.id);
                                      print(notification.itemControlled);
                                      print(notification.predectedClass);
                                      // Handle YES button press
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Center(
                                            key: _dialogKey,
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      try {
                                        final result = await answerPrediction(
                                            notification.id,
                                            notification.itemControlled!,
                                            notification.predectedClass!,
                                            false);

                                        if (_dialogKey.currentContext != null) {
                                          Navigator.of(
                                                  _dialogKey.currentContext!)
                                              .pop();
                                        }
                                        print(result);
                                        if (result) {
                                          // notificationProvider
                                          //     .removeNotification(notification);
                                        } else {
                                          print('error');
                                        }
                                      } catch (e) {
                                        // Handle the error
                                        print('Error: $e');
                                      }
                                      // Handle NO button press
                                      notificationProvider
                                          .removeNotification(notification);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Colors.blueGrey, // Background color
                                      onPrimary: Colors.white, // Text color
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'NO',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),

                // onTap: onTap,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: notification.thumnail.toLowerCase() != 'null' &&
                        notification.thumnail.toLowerCase() != ''
                    ? Image.network(
                        Global.ipadress + '/media/' + notification.thumnail)
                    : SizedBox(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 7,
          right: 15,
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/fail.svg',
                  height: 40,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 10,
                  child: Icon(
                    FontAwesomeIcons
                        .close, // Use any FontAwesomeIcons you prefer
                    color: Colors.blueAccent,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
