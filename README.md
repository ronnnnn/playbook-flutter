<p align="center">
<img src="https://raw.githubusercontent.com/playbook-ui/mediakit/master/logo/default-h%402x.png" alt="Playbook" width="400">
</p>

<p align="center">A library for isolated developing UI components and automatically taking snapshots of them.</p>

# Playbook

`Playbook` is a library that provides a sandbox for building UI components without having to worry about application-specific dependencies, strongly inspired by [Storybook](https://storybook.js.org/) for JavaScript in web-frontend development.  

Components built by using `Playbook` can generate a standalone app as living styleguide.  
This allows you to not only review UI quickly but also deliver more robost designs by separating business logics out of components.

Besides, snapshots of each component can be automatically generated by unit tests, and visual regression testing can be performed using arbitrary third-party tools.

For complex modern app development, it’s important to catch UI changes more sensitively and keep improving them faster.  
With the `Playbook`, you don't have to struggle through preparing the data and spend human resources for manual testings.  

---

### Playbook

`Playbook` components are uniquely stored as scenarios. A `Scenario` has the way to layout component.

```dart
Playbook(
  stories: [
    Story(
      'Home',
      scenarios: [
        Scenario(
          'CategoryHome',
          layout: ScenarioLayout.fill(),
          child: CategoryHome(userData: UserData.stub),
        ),
        Scenario(
          'LandmarkList',
          layout: ScenarioLayout.fill(),
          child: Scaffold(
            appBar: AppBar(),
            body: LandmarkList(userData: UserData.stub),
          ),
        ),
        Scenario(
          'Container red',
          layout: ScenarioLayout.fixed(100, 100),
          child: Container(color: Colors.red),
        ),
      ],
    ),
  ],
);
```

---

### PlaybookUI

`PlaybookUI` provides user interfaces for browsing a list of scenarios.

#### PlaybookGallery

The component visuals are listed and displayed.  
Those that are displayed on the top screen are not actually doing layout, but rather display the snapshots that are efficiently generated at runtime.  

| Browser | Detail |
| ------- | ------ |
|<img src="https://user-images.githubusercontent.com/5707132/143968108-230c2114-3c96-48fa-af1b-17f64b27d9a8.png" width="150">|<img src="https://user-images.githubusercontent.com/5707132/143968151-1775647a-1743-4083-b769-dece364f9d91.png" width="150">|

---

### PlaybookSnapshot

Scenarios can be tested by the instance of types conform to `TestTool` class.
`Snapshot` is one of them, which can generate the snapshots of all scenarios with simulate the screen size and safe area of the given devices.  

```dart
Future<void> main() async {
  await Playbook(
    stories: [
      barStory(),
      fooWidgetStory(),
      assetImageStory(),
    ],
  ).run(
    Snapshot(
      directoryPath: 'screenshots',
      devices: [SnapshotDevice.iPhone8],
    ),
    (widget) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget,
      );
    },
  );
}
```

<img src="https://user-images.githubusercontent.com/5707132/143840952-7c2c3f5b-25cc-4234-8316-73c9ea266620.png" alt="generate images" width="660">

#### Notes

`Snapshot` (internally `flutter test --update-goldens`) requires you to prepare and load the fonts yourself. By defining the location of the font file in `flutter` or `playbook_snapshot` in `pubspec.yaml` and actually preparing the font file in the directory, the font file will be loaded automatically.

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

or

```yaml
playbook_snapshot:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

And then, should be prepared the font file in the directory.

---

### PlaybookGenerator

Supports generating stories and scenarios from `*.story.dart` files.

```dart
// some_file.story.dart

const storyTitle = 'Home';

@GenerateScenario(
  layout: ScenarioLayout.fill(),
)
Widget $CategoryHome() => CategoryHome(userData: UserData.stub);

@GenerateScenario(
  layout: ScenarioLayout.fill(),
)
Widget $LandmarkList() => Scaffold(
      appBar: AppBar(),
      body: LandmarkList(userData: UserData.stub),
    );

@GenerateScenario(
  title: 'Container red',
  layout: ScenarioLayout.fixed(100, 100),
)
Widget containerRed() => Container(color: Colors.red);
```

You can reference the playbook instance.

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playbook Demo',
      theme: ThemeData.light(),
      home: PlaybookGallery(
        title: 'Sample app',
        playbook: playbook,
      ),
    );
  }
}
```

---

### Integration with Third-party Tools

The generated snapshot images can be used for more advanced visual regression testing by using a variety of third party tools.  

#### [percy](https://percy.io)

<img src="https://raw.githubusercontent.com/playbook-ui/playbook-ios/master/assets/percy.png" alt="percy" width="600">

#### [reg-viz/reg-suit](https://github.com/reg-viz/reg-suit)

<img src="https://raw.githubusercontent.com/playbook-ui/playbook-ios/master/assets/reg-report.png" alt="reg-suit" width="600">

---

## Requirements

- Dart 2.12.0+
- flutter 2.0.0+

---

## License

Playbook is released under the [BSD-3-Clause License](./LICENSE).

<br>
<p align="center">
<img alt="Playbook" src="https://raw.githubusercontent.com/playbook-ui/mediakit/master/logo/default%402x.png" width="280">
</p>
