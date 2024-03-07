

import 'dart:async';
import 'dart:convert';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:rxdart/rxdart.dart';

import '../constants/app_constants.dart';
import '../database/share_pref.dart';


class DartPusher {

  PublishSubject<dynamic> messageSentController = PublishSubject();

  Stream<dynamic> messageSentStream() => messageSentController.stream;

  PublishSubject<dynamic> messageSeenController = PublishSubject();

  Stream<dynamic> messageSeenStream() => messageSeenController.stream;

  PublishSubject<dynamic> chatListStreamController = PublishSubject();

  Stream<dynamic> chatListListenStream() => chatListStreamController.stream;

  PublishSubject<dynamic> isAdminStreamController = PublishSubject();

  Stream<dynamic> isAdminListenStream() => isAdminStreamController.stream;


  /////////////////////////////////////////////////////////////////////////////

  PusherChannelsClient connectPusher({String? userId, String? token,bool unScribeChannel = false}) {
    PusherChannelsPackageLogger.enableLogs();


    const hostOptions = PusherChannelsOptions.fromHost(
      scheme: 'wss',
      host: HOST,
      key: PUHSHER_KEY,
      shouldSupplyMetadataQueries: true,
      metadata: PusherChannelsOptionsMetadata.byDefault(),
      port: 6001,
    );

    final client = PusherChannelsClient.websocket(
        options: hostOptions,
        connectionErrorHandler: (exception, trace, refresh) {
          refresh();
        },
        minimumReconnectDelayDuration: const Duration(
          seconds: 120,
        ),
        defaultActivityDuration: const Duration(
          seconds: 120,
        ),
        activityDurationOverride: const Duration(
          seconds: 120,
        ),
        waitForPongDuration: const Duration(
          seconds: 30,
        ));


    final chatUserPrivateChannel = client.privateChannel(
      'private-chat.user.${userId}',
      authorizationDelegate: EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse(AUTH_ENDPOINT),
        onAuthFailed: (dynamic data,StackTrace trace){

        },
        headers: {
          'Content-Type': "application/json",
          'Accept': 'application/json',
          'Authorization': token!,
        },
      ),
    );


    final allChannels = <Channel>[chatUserPrivateChannel];
    final StreamSubscription connectionSubs = client.onConnectionEstablished.listen((data) {
      for (final channel in allChannels) {
        channel.subscribeIfNotUnsubscribed();
      }
    });

    ///////////////////////////////////////////////////////////////////////

    StreamSubscription<ChannelReadEvent> incomingNewMessageEvent =
    chatUserPrivateChannel.bind('incoming.new-message').listen((event) {

      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_incoming_message'] = true;

      chatListStreamController.sink.add(myMap);
    });

    StreamSubscription<ChannelReadEvent> isOptimizeEvent =
    chatUserPrivateChannel.bind('message.video_optimize_complete').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_optimizing'] = true;
      myMap['is_message'] = false;
      myMap['is_typing'] = false;
      myMap['is_reply'] = false;
      myMap['is_edit'] = false;
      myMap['is_delete'] = false;
      myMap['is_seen'] = false;
      messageSentController.sink.add(myMap);
    });

    StreamSubscription<ChannelReadEvent> ringingReminder =
    chatUserPrivateChannel.bind('message.ringing-reminder').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_reminder'] = true;

      chatListStreamController.sink.add(myMap);
    });

    StreamSubscription<ChannelReadEvent> groupMemberRemove =
    chatUserPrivateChannel.bind('room.member-remove').listen((event) {
      ChannelReadEvent myEvent = event;

      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['group_member_remove'] = true;

      chatListStreamController.sink.add(myMap);
    });

    StreamSubscription<ChannelReadEvent> groupDelete =
    chatUserPrivateChannel.bind('group.delete').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['group_delete'] = true;

      chatListStreamController.sink.add(myMap);

    });

    StreamSubscription<ChannelReadEvent> addAdmin =
    chatUserPrivateChannel.bind('room.member-set-admin').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_admin'] = true;
      isAdminStreamController.sink.add(myMap);

    });

    StreamSubscription<ChannelReadEvent> removeAdmin =
    chatUserPrivateChannel.bind('room.member-remove-admin').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_admin'] = false;
      isAdminStreamController.sink.add(myMap);


    });

    StreamSubscription<ChannelReadEvent> messageSentEvent =
    chatUserPrivateChannel.bind('message.sent').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_message'] = true;
      myMap['is_typing'] = false;
      myMap['is_reply'] = false;
      myMap['is_edit'] = false;
      myMap['is_delete'] = false;
      myMap['is_seen'] = false;
      messageSentController.sink.add(myMap);
      // SharedPref.getData(key: SharedPref.owner_id).then((value) {
      //   if (myMap['messages'][0]['owner_id'] == value) {
      //   } else {
      //     messageSentController.sink.add(myMap);
      //   }
      // });
    });

    StreamSubscription<ChannelReadEvent> messageReplyEvent =
    chatUserPrivateChannel.bind('message.reply').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_reply'] = true;
      myMap['is_message'] = false;
      myMap['is_typing'] = false;
      myMap['is_edit'] = false;
      myMap['is_delete'] = false;
      myMap['is_seen'] = false;

      SharedPref.getData(key: SharedPref.owner_id).then((value) {
        if (myMap['message']['owner_id'] == value) {
        } else {
          messageSentController.sink.add(myMap);
        }
      });
    });

    //Edit
    StreamSubscription<ChannelReadEvent> messageEditEvent =
    chatUserPrivateChannel.bind('message.edit').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_edit'] = true;
      myMap['is_reply'] = false;
      myMap['is_message'] = false;
      myMap['is_typing'] = false;
      myMap['is_delete'] = false;
      myMap['is_seen'] = false;

      SharedPref.getData(key: SharedPref.owner_id).then((value) {
        if (myMap['message']['owner_id'] == value) {
        } else {
          messageSentController.sink.add(myMap);
        }
      });
    });

    //Reaction
    StreamSubscription<ChannelReadEvent> messageReactionEvent =
    chatUserPrivateChannel.bind('message.reaction').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);


      myMap['is_edit'] = true;
      myMap['is_reply'] = false;
      myMap['is_message'] = false;
      myMap['is_typing'] = false;
      myMap['is_delete'] = false;
      myMap['is_seen'] = false;

      messageSentController.sink.add(myMap);

    });

    //Seen / Deliver
    StreamSubscription<ChannelReadEvent> messageSeenEvent =
    chatUserPrivateChannel.bind('message.seen').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_seen'] = true;

      messageSeenController.sink.add(myMap);
    });

    //Delete
    StreamSubscription<ChannelReadEvent> messageDeleteEvent =
    chatUserPrivateChannel.bind('message.delete').listen((event) {
      ChannelReadEvent myEvent = event;
      Map<String, dynamic> myMap = jsonDecode(myEvent.data);
      myMap['is_delete'] = true;
      myMap['is_edit'] = false;
      myMap['is_reply'] = false;
      myMap['is_message'] = false;
      myMap['is_typing'] = false;
      myMap['is_seen'] = false;

      SharedPref.getData(key: SharedPref.owner_id).then((value) {
        if (myMap['message']['owner_id'] == value) {
        } else {
          messageSentController.sink.add(myMap);
        }
      });
    });


    if(unScribeChannel){
      connectionSubs.cancel();
      client.disconnect();
      client.dispose();
    }else{
      client.connect();

    }

    return client;
  }




}