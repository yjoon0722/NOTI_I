import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TdiClient.g.dart';

@RestApi(baseUrl: "https://appservice9.com")
abstract class TdiClient {

  factory TdiClient (Dio dio, {String baseUrl}) = _TdiClient;

  /** 인스톨 레퍼러 보내기 */
  @POST ('/api/v1/landing/install')
  Future<void> postInstallRefererInfo (
      @Header("x-tdi-client-secret") String secret_key,
      @Body() InstallRefererInfoDto body
  );

}

@JsonSerializable()
class InstallRefererInfoDto {

  String? referrer;
  String? app_version;
  String? adid;

  InstallRefererInfoDto ({
    this.referrer,
    this.app_version,
    this.adid
  });

  factory InstallRefererInfoDto.fromJson (Map<String, dynamic> json) => _$InstallRefererInfoDtoFromJson (json);
  Map<String, dynamic> toJson () => _$InstallRefererInfoDtoToJson (this);

}

