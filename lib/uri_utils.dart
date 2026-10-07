/// Whether a decoded QR payload looks like a URI with a scheme (http, tel,
/// mailto, sms, etc.) rather than plain text. Non-URI payloads (Wi-Fi
/// credentials, vCard, plain text) are out of scope for v1 and shown as raw
/// text with no open action.
bool isOpenableUri(String rawValue) {
  final uri = Uri.tryParse(rawValue.trim());
  if (uri == null) return false;
  return uri.scheme.isNotEmpty && uri.hasAuthority || _hasNonHttpScheme(uri);
}

bool _hasNonHttpScheme(Uri uri) {
  const nonAuthoritySchemes = {'tel', 'mailto', 'sms'};
  return nonAuthoritySchemes.contains(uri.scheme.toLowerCase());
}
