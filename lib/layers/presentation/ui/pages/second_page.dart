import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_setup/layers/bloc/counter_bloc.dart';
import 'package:location/location.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../global.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  PermissionStatus? _permissionGranted;
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  initState() {
    super.initState();
    getUserLocation();
  }

  Future<bool> checkForServiceAvailability() async {
    bool isEnabled = await location.serviceEnabled();
    if (isEnabled) {
      return Future.value(true);
    }

    isEnabled = await location.requestService();

    if (isEnabled) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> checkForPermission() async {
    PermissionStatus status = await location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await location.requestPermission();
      if (status == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    if (status == PermissionStatus.deniedForever) {
      // show snackbar
      return false;
    }
    return Future.value(true);
  }

  Future<void> getUserLocation() async {
    print(" Available --->");
    if (!(await checkForServiceAvailability())) {
      print("Service Not Available --->");
      return;
    }
    if (!(await checkForPermission())) {
      print("Permission not given --->");
      return;
    }

    // final LocationData data = await location.getLocation();
    // print("Data ---> ${data.latitude} ${data.longitude}");

    _listenLocation();
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        print("Platform Err -> $err");
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((currentLocation) {
      print('currentLocation -> ${currentLocation.latitude} ${currentLocation.longitude}');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
      ),
      body: StreamBuilder<int>(
          stream: bloc.stream,
          initialData: bloc.value,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  snapshot.data != null ? Text(snapshot.data.toString()) : Container(),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final List<AssetEntity>? result = await AssetPicker.pickAssets(
                          context,
                          pickerConfig: const AssetPickerConfig(),
                        );
                        // bloc.increment();
                        //context.go('/third_page');
                      },
                      child: Text("Go to Third")),
                  ElevatedButton(
                      onPressed: () {
                        bloc.decrement();
                        //context.go('/third_page');
                      },
                      child: Text("Go to Third")),
                ],
              ),
            );
          }),
    );
  }
}
