#!/usr/bin/env sh
flutter clean \
&& flutter build aar --build-number=dev-snapshot --release --no-debug --no-profile \
&& cd ./build/host/outputs/repo \
&& mc alias set minio/ http://192.168.1.39:9000 RQp7LQhKCdufhjj4oYuLBm7GHkY6qwX4 XBirH0y8fc4r8aShkjzGsevjLLt1GAgH \
&& mc cp --recursive . minio/flutter-wallet-repo \
&& cd ../../../../
