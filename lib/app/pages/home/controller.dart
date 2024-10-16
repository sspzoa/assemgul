import 'package:get/get.dart';

class HomePageController extends GetxController {
  final smallContainers = List.generate(3, (index) => '').obs;
  final selectedContainerIndex = RxnInt();
  final combinedCharacter = ''.obs;
  final matchingWords = <String>[].obs;

  // 초성 리스트
  final List<String> choseong = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];

  // 중성 리스트
  final List<String> jungseong = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'
  ];

  // 종성 리스트
  final List<String> jongseong = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];

  // 간단한 사전
  final List<String> dictionary = [
    '달', '달리기', '달콤한', '달다', '달라지다', '달라지지'
  ];

  void selectCharacter(String character) {
    if (selectedContainerIndex.value != null) {
      smallContainers[selectedContainerIndex.value!] = character;
      selectedContainerIndex.value = null;
      updateCombinedCharacter();
      update();
    }
  }

  void selectSmallContainer(int index) {
    if (selectedContainerIndex.value == index) {
      selectedContainerIndex.value = null;
    } else {
      selectedContainerIndex.value = index;
    }
    update();
  }

  List<String> getCurrentList() {
    switch (selectedContainerIndex.value) {
      case 0:
        return choseong;
      case 1:
        return jungseong;
      case 2:
        return jongseong;
      default:
        return [];
    }
  }

  void clearSelectedContainer() {
    if (selectedContainerIndex.value != null) {
      smallContainers[selectedContainerIndex.value!] = '';
      updateCombinedCharacter();
      update();
    }
  }

  void updateCombinedCharacter() {
    if (smallContainers[0].isNotEmpty && smallContainers[1].isNotEmpty) {
      int cho = choseong.indexOf(smallContainers[0]);
      int jung = jungseong.indexOf(smallContainers[1]);
      int jong = jongseong.indexOf(smallContainers[2]);

      if (cho != -1 && jung != -1) {
        int unicodeValue = 0xAC00 + (cho * 21 + jung) * 28 + (jong == -1 ? 0 : jong);
        combinedCharacter.value = String.fromCharCode(unicodeValue);
        findMatchingWords();
      } else {
        combinedCharacter.value = '';
        matchingWords.clear();
      }
    } else {
      combinedCharacter.value = '';
      matchingWords.clear();
    }
  }

  void findMatchingWords() {
    if (combinedCharacter.value.isEmpty) {
      matchingWords.clear();
    } else {
      matchingWords.value = dictionary.where((word) => word.contains(combinedCharacter.value)).toList();
    }
  }

  void onCombinedCharacterTap() {
    findMatchingWords();
  }
}