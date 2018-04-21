FROM lastjedi/jdk8:0.1

# Update packages 
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip wget bash git curl lib32stdc++6 xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Install android sdk
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
ENV ANDROID_HOME /opt/android-sdk

RUN cd /opt && wget -q ${ANDROID_SDK_URL} --show-progress 
RUN cd /opt && unzip sdk-tools-linux-3859397.zip -d $ANDROID_HOME && rm sdk-tools-linux-3859397.zip
 	
# Add android tools and platform tools to PATH 
ENV PATH $PATH:$ANDROID_HOME/tools 
ENV PATH $PATH:$ANDROID_HOME/platform-tools 
ENV PATH $PATH:$ANDROID_HOME/tools/bin

#Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools"
RUN yes | sdkmanager "build-tools;26.0.2" --verbose
RUN yes | sdkmanager "platforms;android-25" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose
RUN yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" --verbose
RUN yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" --verbose
RUN yes | sdkmanager "system-images;android-25;google_apis;x86_64" --verbose
RUN yes | sdkmanager --licenses 

# Create fake keymap file 
RUN mkdir $ANDROID_HOME/tools/keymaps && \
    touch $ANDROID_HOME/tools/keymaps/de-de

#Create AVD
RUN echo no | avdmanager create avd --force -n nexus -k "system-images;android-25;google_apis;x86_64" --abi "google_apis/x86_64"

RUN cd /opt && wget -q https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_v0.2.8-beta.tar.xz  --show-progress 
RUN cd /opt && tar xf flutter_linux_v0.2.8-beta.tar.xz && rm flutter_linux_v0.2.8-beta.tar.xz
ENV PATH=/opt/flutter/bin:$PATH 

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends  locales && \
    rm -rf /var/lib/apt/lists/* 
ENV LANG de_DE.UTF-8 
RUN locale-gen $LANG

RUN flutter doctor -v

ENV VSCODE=https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable

RUN apt-get update && \
    apt-get install -y --no-install-recommends libnotify4 gnupg libxkbfile1 libgconf-2-4 libsecret-1-0 libgtk2.0-0 libx11-xcb-dev libxss-dev libasound2 libnss3 libxtst6 && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'Installing VsCode' && \ 
    curl -o vscode.deb -# -J -L "$VSCODE" && \ 
    dpkg -i vscode.deb && rm -f vscode.deb

ENV DEVELOPER developer
RUN useradd -ms /bin/bash ${DEVELOPER}
USER ${DEVELOPER}
WORKDIR /home/${DEVELOPER}

RUN code --install-extension Dart-Code.flutter



