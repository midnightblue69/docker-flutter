FROM lastjedi/jdk8:0.2

# Update packages 
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip wget bash git curl lib32stdc++6 xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Install android sdk
ENV ANDROID_SDK sdk-tools-linux-4333796.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK}
ENV ANDROID_HOME /opt/android-sdk

RUN cd /opt && wget -q ${ANDROID_SDK_URL} --show-progress 
RUN cd /opt && unzip ${ANDROID_SDK} -d $ANDROID_HOME && rm ${ANDROID_SDK}
 	
# Add android tools and platform tools to PATH 
ENV PATH $PATH:$ANDROID_HOME/tools 
ENV PATH $PATH:$ANDROID_HOME/platform-tools 
ENV PATH $PATH:$ANDROID_HOME/tools/bin

#Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools"
RUN yes | sdkmanager "build-tools;28.0.3" --verbose
RUN yes | sdkmanager "platforms;android-28" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose
RUN yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" --verbose
RUN yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" --verbose
RUN yes | sdkmanager "system-images;android-28;google_apis;x86" --verbose
RUN yes | sdkmanager --licenses 

# Create fake keymap file 
RUN mkdir $ANDROID_HOME/tools/keymaps && \
    touch $ANDROID_HOME/tools/keymaps/de-de

ENV FLUTTER_TAR flutter_linux_v1.7.8+hotfix.4-stable.tar.xz
                       
RUN cd /opt && wget -q https://storage.googleapis.com/flutter_infra/releases/stable/linux/${FLUTTER_TAR}  --show-progress 
RUN cd /opt && tar xf ${FLUTTER_TAR} && rm ${FLUTTER_TAR}
ENV PATH=/opt/flutter/bin:$PATH 

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends  locales && \
    rm -rf /var/lib/apt/lists/* 
ENV LANG de_DE.UTF-8 
RUN locale-gen $LANG

ENV VSCODE=https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable

RUN apt-get update && \
    apt-get install -y --no-install-recommends libnotify4 gnupg libxkbfile1 libgconf-2-4 libsecret-1-0 libgtk2.0-0 libx11-xcb-dev libxss-dev libasound2 libnss3 libxtst6 pulseaudio libgl1-mesa-glx libgtkd-3-0 qemu-kvm cpu-checker android-tools-adb && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'Installing VsCode' && \ 
    curl -o vscode.deb -# -J -L "$VSCODE" && \ 
    dpkg -i vscode.deb && rm -f vscode.deb

RUN groupadd flutter
RUN usermod -a -G flutter root

RUN chown -R :flutter /opt/flutter
RUN chmod -R g+xrw /opt/flutter
RUN chown -R :flutter /opt/android-sdk
RUN chmod -R g+xrw /opt/android-sdk

ENV DEVELOPER developer
ENV HOME_DIR /home/${DEVELOPER}
RUN useradd -ms /bin/bash ${DEVELOPER}
RUN usermod -a -G flutter developer
RUN usermod -a -G plugdev developer
USER ${DEVELOPER}
WORKDIR ${HOME_DIR}

ADD .bashrc .bashrc
RUN cat /usr/lib/git-core/git-sh-prompt > .bash_git

# code as superuser is not recommended 
RUN code --install-extension Dart-Code.flutter

RUN flutter doctor -v




