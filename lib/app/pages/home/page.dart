import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

import 'controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomColors colorTheme = Theme.of(context).extension<CustomColors>()!;
    final CustomTypography textTheme = Theme.of(context).extension<CustomTypography>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCharacterGrid(colorTheme, textTheme),
                const SizedBox(height: 32),
                _buildBottomSection(colorTheme, textTheme),
                const SizedBox(height: 64),
                _buildMatchingWords(colorTheme, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGrid(CustomColors colorTheme, CustomTypography textTheme) {
    return Obx(() {
      List<String> characters = controller.getCurrentList();
      return SizedBox(
        height: 220,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: characters.map((char) => _buildCharacterTile(char, colorTheme, textTheme)).toList(),
        ),
      );
    });
  }

  Widget _buildCharacterTile(String character, CustomColors colorTheme, CustomTypography textTheme) {
    return GestureDetector(
      onTap: () => controller.selectCharacter(character),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorTheme.backgroundStandardSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(character, style: textTheme.title),
        ),
      ),
    );
  }

  Widget _buildBottomSection(CustomColors colorTheme, CustomTypography textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildSmallContainer(0, 64, colorTheme, textTheme),
            const SizedBox(height: 16),
            _buildCombinedCharacterContainer(150, colorTheme, textTheme),
            const SizedBox(height: 16),
            _buildSmallContainer(2, 64, colorTheme, textTheme),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            _buildSmallContainer(1, 64, colorTheme, textTheme),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallContainer(int index, double size, CustomColors colorTheme, CustomTypography textTheme) {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectSmallContainer(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: controller.selectedContainerIndex.value == index
              ? colorTheme.coreAccentTranslucent
              : colorTheme.backgroundStandardSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                controller.smallContainers[index],
                style: textTheme.title,
              ),
            ),
            if (controller.selectedContainerIndex.value == index && controller.smallContainers[index].isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: controller.clearSelectedContainer,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorTheme.solidBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.clear,
                      size: 16,
                      color: colorTheme.backgroundStandardPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Widget _buildCombinedCharacterContainer(double size, CustomColors colorTheme, CustomTypography textTheme) {
    return Obx(() => GestureDetector(
      onTap: controller.onCombinedCharacterTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorTheme.backgroundStandardSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            controller.combinedCharacter.value,
            style: textTheme.title.copyWith(fontSize: 72),
          ),
        ),
      ),
    ));
  }

  Widget _buildMatchingWords(CustomColors colorTheme, CustomTypography textTheme) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('사용되는 단어', style: textTheme.heading),
        const SizedBox(height: 16),
        controller.matchingWords.isEmpty
            ? Text('없음', style: textTheme.body.copyWith(color: colorTheme.coreAccent))
            : Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.matchingWords.map((word) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorTheme.backgroundStandardSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(word, style: textTheme.body),
              )
          ).toList(),
        ),
      ],
    ));
  }
}