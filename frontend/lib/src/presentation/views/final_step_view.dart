import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:myspots/src/presentation/widgets/inputs/TextInput.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myspots/src/services/models.dart' as model;

@RoutePage()
class FinalStepView extends StatelessWidget {
  String tags = '';
  String description = '';
  String caption = '';
  String spotName = '';

  final _loginFormKey = GlobalKey<FormState>();
  final String videoUrl;
  final String thumbnailUrl;

  FinalStepView({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  Future<void> _submit(BuildContext context) async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    context.read<model.AppState>().startLoading();

    final location = await getLocation();

    await BackendService().createReel(
      model.Reel(
        videoUrl: videoUrl,
        caption: caption,
        description: description,
        thumbnailUrl: thumbnailUrl,
        location: location,
        spotName: spotName,
      ),
      tags,
    );

    context.read<model.AppState>().stopLoading();

    context.router.push(DashboardRoute());
  }

  Future<List<double>> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle permission denied
      return [0.0, 0.0];
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permission denied forever
      return [0.0, 0.0];
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Do something with latitude and longitude
      return [latitude, longitude];
    }

    return [0.0, 0.0];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainHeading(text: 'Enter spot info below to post reel!'),
              const SizedBox(height: 20),
              Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextInput(
                      labelText: 'Tags',
                      isTextBox: true,
                      prefixIcon: Icon(Icons.tag_outlined),
                      onChanged: (v) => tags = v,
                      validator: (v) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      labelText: 'Description',
                      isTextBox: true,
                      prefixIcon: Icon(Icons.description_outlined),
                      onChanged: (v) => description = v,
                      validator: (v) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      labelText: 'Caption',
                      prefixIcon: Icon(Icons.closed_caption_outlined),
                      onChanged: (v) => caption = v,
                      validator: (v) {
                        if (v == null) {
                          return "Please enter caption for your spot";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      labelText: 'Spot name',
                      prefixIcon: Icon(Icons.location_pin),
                      onChanged: (v) => spotName = v,
                      validator: (v) {
                        if (v == null) {
                          return "Please enter name of your spot";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      buttonText: 'Post Reel',
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
