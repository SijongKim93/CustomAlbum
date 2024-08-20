# **Custom Album**

<img src="https://github.com/user-attachments/assets/5f8da2c2-2bc6-459e-b9b3-721e6e20706d" width="200" height="400"/>  <img src="https://github.com/user-attachments/assets/2701678b-b34b-4e9d-81ef-3cd7adc0150a" width="200" height="400"/>  <img src="https://github.com/user-attachments/assets/d085729e-e034-48e2-99b5-f1dc1b07e192" width="200" height="400"/> 



## 1. 프로젝트 설명

### Custom Album

사전 과제 주제인 iOS 사진 앱과 같은 앱을 구현하기 위해 `PHAsset`을 통해 사진 라이브러리에 저장되어 있는 사진을 자동으로 동기화하여 관리하고, 다양한 필터 및 조정, 자르기, 블러 등 사진을 편집할 수 있는 기능을 구현했습니다.

`CoreImage`를 활용해 가져온 사진을 편집(필터, 자르기, 조정, 블러 등)해 저장하여 사진 라이브러리에 추가할 수 있고, `CoreData`를 활용해 즐겨찾기 된 사진을 별도로 저장해 관리할 수 있도록 구현했습니다.

- **아키텍처 구조**: MVVM
- **사용 언어**: SwiftUI
- **비동기 처리**: Combine, Swift Concurrency, GCD
- **프레임워크**: Core Image, Core Data, Photos(PHAsset), CoreLocation, Combine

## 2. 주요 트러블 슈팅

### 1. 디바이스 연결 시 대량의 사진 라이브러리 데이터로 앱 과부화 현상

- **문제**: 초기 구현 시 사진과 연결하여 앨범에 있는 사진을 동기화 했으나, 다수의 데이터로 인해 앱이 과부화되어 정상적으로 작동하지 않는 문제가 발생했습니다.
- **해결**: LazyGrid를 사용해도 과부화 문제가 해결되지 않아, 페이지네이션을 적용하여 스크롤 시 50장씩 사진을 로드하도록 변경했습니다. 이를 통해 과도한 데이터 로드로 인한 앱 과부화 문제를 해결하고, 더 빠르게 데이터를 전달받을 수 있게 되었습니다.

### 2. AlbumView와 FavoriteView가 하나의 FullScreenPhotoView를 공유하면서 발생하는 타입 불일치 오류

![image](https://github.com/user-attachments/assets/3e9abdc0-2acf-480c-8a89-3a338a0333b6)


- **문제**: 각각의 사진을 가지고 있는 뷰에서 사진 클릭 후 FullScreenPhotoView로 넘어갈 때 Photo와 Favorite의 배열이 서로 다른 타입으로 저장되어 있어 타입 불일치 오류가 발생했습니다.
- **해결**: Favorite의 값을 Photo에 매치해 타입을 일치시키는 방식으로 오류를 수정했습니다.

### 3. 이미지 편집 중 필터, 조정, 자르기, 블러 등 각각의 이미지 편집 과정에서 발생하는 충돌

![image](https://github.com/user-attachments/assets/b318240b-795e-4c94-a867-396a3b4333b4)

- **문제**: 각 이미지 편집 기능이 충돌하여, 편집된 이미지가 아닌 원본 이미지가 저장되는 문제와 다른 편집 기능이 작동하지 않는 오류가 있었습니다.
- **해결**: 각 편집 과정에서 적용되는 이미지를 개별적으로 관리하도록 설정했습니다. 기능별로 뷰 모델을 분리하여 각 이미지 편집 결과를 독립적으로 관리하고, 최종 이미지를 통합하여 전달하는 방식으로 로직을 수정했습니다.

## 3. 주요 기능

### 1. 사진 동기화

- 사진 라이브러리에서 사진을 동기화하여 앨범을 관리하고, 즐겨찾기에 추가하거나 삭제하는 기능을 제공합니다.
- 모든 사진을 스크롤하여 탐색이 가능하며, 사진을 터치해 상세 정보를 확인할 수 있습니다.

### 2. 사진 편집

- 다양한 필터를 적용해 사진을 변경할 수 있습니다.
- 밝기, 대비, 채도, 선명도, 노출 등 다양한 속성을 조정해 세밀한 이미지 편집이 가능합니다.
- CropBox를 활용해 원하는 이미지 사이즈로 자를 수 있습니다.
- 원하는 위치를 클릭해 블러 효과를 적용할 수 있습니다.

### 3. 데이터 저장

- CoreData를 사용해 즐겨찾기 상태를 별도로 저장할 수 있도록 구현했습니다.

## 4. 이미지 처리

### 1. 필터 적용

- CoreImage의 다양한 필터를 활용해 사진에 효과를 적용할 수 있습니다.
- 사용 가능한 필터: Sepia Tone, Noir, Chrome, Instant, Fade, Monochrome, Posterize, Vignette.
- `applyFilter` 메서드를 통해 필터 이름을 지정하고 필터가 적용된 이미지를 반환하는 로직으로 구현했습니다.

### 2. 자르기 적용

- 사진의 특정 영역을 자르거나, 정사각형, 4:3 등의 비율로 자를 수 있는 기능을 제공합니다.
- CropBox를 활용해 원하는 만큼 사이즈를 조정할 수 있습니다.

### 3. 이미지 조정

- CoreImage를 활용해 밝기, 대비, 채도, 선명도, 노출, 생동감, 하이라이트 등 이미지 속성을 세밀하게 조정할 수 있습니다.
- 편집한 설정값이 실시간으로 이미지에 반영됩니다.

### 4. 블러 효과

- 사용자가 화면에 터치한 위치에 블러 효과를 적용할 수 있습니다.
- `applyBlur` 메서드를 통해 사용자가 터치한 위치를 중심으로 블러가 적용되며, 마스크를 활용해 자연스러운 블러 효과를 생성합니다.

## 5. 사진 관리

### 1. CoreData

- `saveFavoritePhoto`, `deleteFavoritePhoto` 메서드를 활용해 즐겨찾기 상태의 사진을 저장하거나 삭제할 수 있습니다.
- CoreData를 통해 저장된 데이터를 `fetchFavoritePhotos` 메서드를 사용해 실시간으로 로드합니다.

### 2. 사진 라이브러리 접근

- PermissionManager를 활용해 앱 실행 시 사용자의 사진 라이브러리 접근 권한을 확인하고, 권한이 승인되면 PHAsset을 통해 사진 라이브러리에 저장된 사진을 로드합니다.
- 권한이 승인되지 않은 경우, `openSettingsURLString`을 사용해 권한을 다시 승인할 수 있도록 유도하는 방식으로 구현했습니다.

## 6. GitHub
![image](https://github.com/user-attachments/assets/2462cb96-0d7f-40dc-82b7-12e3b4eedeec)


- Private repository를 통해 각 상황별 개발 진행 과정을 기록했습니다.

![image](https://github.com/user-attachments/assets/bc475bf3-c83f-4550-8d3d-aeb99681d02e)


- 기능 구현 별로 브랜치를 나눠 해당 기능을 구현하고, 각 브랜치에 대한 히스토리를 관리했습니다.
