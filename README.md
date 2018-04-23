Contains:
  * ubuntu 17.10
  * flutter
  * android-27
  * vscode with Dart-Plugin
  * default user developer
  * german locales

run it:
```sudo docker run --name yourapp -it --rm -e DISPLAY=$DISPLAY -h flutter -v /tmp/.X11-unix:/tmp/.X11-unix -v yourapp:/home/developer -v /etc/localtime:/etc/localtime:ro  -v /usr/share/icons:/usr/share/icons:ro -v /dev/kvm:/dev/kvm --privileged  lastjedi/flutter /bin/bash```

check image:
* create android image: ```avdmanager create avd --force -n nexus -k "system-images;android-27;google_apis;x86" --abi "google_apis/x86"```
* change to ```cd $ANDROID_HOME\emulator```
* start emulator ```./emulator -verbose @nexus -noaudio -accel on -use-system-libs```
* start flutter in new command ```sudo docker exec -it yourapp bash``` 
* ```flutter create yourapp```
* ```cd yourapp```
* ```flutter run```
* check hot relaod. start new command ```sudo docker exec -it yourapp bash``` 
* start vscode```code```
* open ```lib/main.dart```
* change ```You have pushed the button this many times:``` to ```You have clicked the button this many times```
* change to flutter-terminal and press r
