import 'package:get/get.dart';
import '../../core/utils/supabase.dart';

class HomePageController extends GetxController {
  final smallContainers = List.generate(3, (index) => '').obs;
  final selectedContainerIndex = RxnInt();
  final combinedCharacter = ''.obs;
  final matchingWords = <String>[].obs;

  final choseong = <String>[].obs;
  final jungseong = <String>[].obs;
  final jongseong = <String>[].obs;
  final dictionary = <String>[].obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final koreanCharactersResponse = await SupabaseConfig.client
          .from('korean_characters')
          .select()
          .single();

      if (koreanCharactersResponse != null) {
        choseong.value = List<String>.from(koreanCharactersResponse['choseong'] ?? []);
        jungseong.value = List<String>.from(koreanCharactersResponse['jungseong'] ?? []);
        jongseong.value = List<String>.from(koreanCharactersResponse['jongseong'] ?? []);
      }

      final dictionaryResponse = await SupabaseConfig.client
          .from('dictionary')
          .select('word');

      if (dictionaryResponse != null) {
        dictionary.value = List<String>.from(dictionaryResponse.map((item) => item['word'] as String));
      }
    } catch (e) {
      print('Error fetching data: $e');
      errorMessage.value = '데이터를 불러오는 데 실패했습니다. 다시 시도해 주세요.';
    } finally {
      isLoading.value = false;
    }
  }

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