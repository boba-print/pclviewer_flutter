<div align="center">
    <img src="./assets/boba_logo.png" alt="boba-logo" width="128px" />

# 👀 Boba PCL Viewer

[![license](https://img.shields.io/badge/License-AGPL%203.0-blue.svg)](https://github.com/boba-print/pclviewer_flutter/master/LICENSE)

<img src="./readme-images/app.png" alt="app image" width="500px"/>
</div>

# 👀 Boba PCL Viewer

> GhostScript와 Flutter를 사용해 HP Printer Command Languages (PCL)파일을 PDF로 변환해 주는 앱입니다. (Flutter앱에 GhostScript를 내장하였습니다.)

- 변환하고자 하는 pcl 파일을 **선택**, 또는 **드래그 앤 드롭**하여 변환할 수 있습니다.
- pcl에 대한 **기본 열기 앱**으로 지정하여 바로 변환할 수 있습니다.

|             | Windows           | macOS | Linux        |
| ----------- | ----------------- | ----- | ------------ |
| **Support** | Windows 8, 10, 11 | 11.0+ | Coming soon! |

# 빌드 방법

## Windows

```bash
$ ./build.bat
```

위 스크립트를 통해 생성된 실행파일을 패키징하기 위해서 `Inno Setup` Software를 사용하였습니다.
루트 폴더에 있는 `win-installer.iss` 를 열어 Inno로 Run 하시면 인스톨러 파일이 함께 생성됩니다.

Inno를 통해 생성된 인스톨러로 설치할 경우 다음과 같은 장점이 있습니다.

- 별도의 작업 없이도 바탕화면에 바로가기를 만들 수 있음
- `.pcl` 확장자에 대해 자동으로 기본앱으로 설정해줌
- `programfiles(x86)`으로 자동 설치됨
- ...

## macOS

```bash
$ ./build.sh
```

위 스크립트를 통해 dmg파일이 생성되는데 이를 Applications 폴더에 설치하면 pcl 확장자에 대해 기본앱으로 지정 됩니다.