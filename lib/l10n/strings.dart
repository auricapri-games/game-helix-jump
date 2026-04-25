import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Tiny manual i18n layer. Three locales (pt/en/es). Resolved by the app
/// `Localizations.localeOf(context)` and exposed via [S.of].
class S {
  const S._(this.locale);

  final Locale locale;

  static S of(BuildContext context) {
    final l = Localizations.maybeLocaleOf(context) ?? const Locale('pt');
    return S._(l);
  }

  String _t(String pt, String en, String es) {
    switch (locale.languageCode) {
      case 'en':
        return en;
      case 'es':
        return es;
      case 'pt':
      default:
        return pt;
    }
  }

  String get appTitle => _t('Helix Jump', 'Helix Jump', 'Helix Jump');
  String get tagline => _t(
        'Desça pelo helix, fuja do vermelho.',
        'Drop through the helix, dodge the red.',
        'Baja por el helix, esquiva el rojo.',
      );
  String get play => _t('JOGAR', 'PLAY', 'JUGAR');
  String get levelSelect => _t('Selecionar fase', 'Select level', 'Elegir fase');
  String get settings => _t('Configurações', 'Settings', 'Ajustes');
  String get removeAds => _t('Remover anúncios', 'Remove ads', 'Quitar anuncios');
  String get legal => _t('Termos e privacidade', 'Terms & privacy', 'Términos');
  String get bestScore => _t('Recorde', 'Best', 'Récord');
  String get score => _t('Pontos', 'Score', 'Puntos');
  String get phase => _t('Fase', 'Phase', 'Fase');
  String get tapToDrop => _t('Toque para soltar', 'Tap to drop', 'Toca para soltar');
  String get rotateLeft => _t('Girar esquerda', 'Rotate left', 'Girar izquierda');
  String get rotateRight => _t('Girar direita', 'Rotate right', 'Girar derecha');
  String get drop => _t('SOLTAR', 'DROP', 'SOLTAR');
  String get backHome => _t('Voltar', 'Back', 'Volver');
  String get retry => _t('Tentar novamente', 'Try again', 'Reintentar');
  String get next => _t('Próxima fase', 'Next phase', 'Siguiente fase');
  String get gameOver => _t('Fim de jogo', 'Game over', 'Fin del juego');
  String get levelComplete => _t('Fase completa!', 'Level complete!', '¡Nivel completo!');
  String get sound => _t('Som', 'Sound', 'Sonido');
  String get vibration => _t('Vibração', 'Vibration', 'Vibración');
  String get language => _t('Idioma', 'Language', 'Idioma');
  String get loading => _t('Carregando...', 'Loading...', 'Cargando...');
  String get removeAdsBody => _t(
        'Sem anúncios. Suporta o desenvolvedor.',
        'No ads. Supports the developer.',
        'Sin anuncios. Apoya al desarrollador.',
      );
  String get removeAdsCta => _t('Em breve', 'Coming soon', 'Pronto');
  String get howToPlay => _t('Como jogar', 'How to play', 'Cómo jugar');
  String get howToPlayBody => _t(
        'Arraste para girar a torre. A bolinha cai sozinha — desvie das plataformas vermelhas para somar pontos.',
        'Drag to rotate the tower. The ball falls on its own — dodge the red platforms to score.',
        'Arrastra para girar la torre. La pelota cae sola — esquiva las rojas para sumar.',
      );
  String get gameplayHint => _t(
        'Arraste para girar e desviar do vermelho.',
        'Drag to rotate and avoid the red.',
        'Arrastra para girar y esquivar el rojo.',
      );
  String get hint => _t('Dica', 'Tip', 'Pista');
}
