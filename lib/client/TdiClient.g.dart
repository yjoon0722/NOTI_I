// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TdiClient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallRefererInfoDto _$InstallRefererInfoDtoFromJson(
        Map<String, dynamic> json) =>
    InstallRefererInfoDto(
      referrer: json['referrer'] as String?,
      app_version: json['app_version'] as String?,
      adid: json['adid'] as String?,
    );

Map<String, dynamic> _$InstallRefererInfoDtoToJson(
        InstallRefererInfoDto instance) =>
    <String, dynamic>{
      'referrer': instance.referrer,
      'app_version': instance.app_version,
      'adid': instance.adid,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TdiClient implements TdiClient {
  _TdiClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://appservice9.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<void> postInstallRefererInfo(secret_kdy, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'x-tdi-client-secret': secret_kdy};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    await _dio.fetch<void>(_setStreamType<void>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/api/v1/landing/install',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
