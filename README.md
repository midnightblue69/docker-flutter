# contains
  * ubuntu 18.04
  * flutter
  * android-28
  * vscode (with Dart-Plugin, if you build it on your own - not included in the image)
  * default user developer

# run it

```sudo docker run --name yourapp -it --rm -e DISPLAY=$DISPLAY -h flutter -v /tmp/.X11-unix:/tmp/.X11-unix -v yourapp:/home/developer -v /etc/localtime:/etc/localtime:ro  -v /usr/share/icons:/usr/share/icons:ro -v /usr/share/fonts:/usr/share/fonts:ro -v /dev/kvm:/dev/kvm --privileged  lastjedi/flutter /bin/bash```

# check image
* set kvm permissions ```sudo docker exec -it --user root yourapp bash``` and enter ```chown {Username} /dev/kvm``` then ```exit```.
* create android image: ```avdmanager create avd --force -n nexus -k "system-images;android-28;google_apis;x86" --abi "google_apis/x86"```
* change to ```cd $ANDROID_HOME/emulator```
* start emulator ```./emulator -verbose @nexus -noaudio -accel on -use-system-libs```
* start flutter in new command ```sudo docker exec -it yourapp bash``` 
* ```flutter create yourapp```
* ```cd yourapp```
* ```flutter run```
* check hot reload. start new command ```sudo docker exec -it yourapp bash``` 
* start vscode```code```
* open ```lib/main.dart```
* change ```You have pushed the button this many times:``` to ```You have clicked the button this many times``` and save file.
* change to flutter-terminal and press r

# upgrade flutter

as root 
```sudo docker exec -it --user root yourapp bash```

```flutter upgrade```

