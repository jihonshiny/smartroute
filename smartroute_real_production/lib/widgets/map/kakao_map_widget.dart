import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../app/config.dart';
import '../../../models/place.dart';

class KakaoMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int level;
  final List<Place> markers;
  final Function(double lat, double lng)? onMapTap;

  const KakaoMapWidget({
    super.key,
    this.latitude = AppConfig.defaultLat,
    this.longitude = AppConfig.defaultLng,
    this.level = 3,
    this.markers = const [],
    this.onMapTap,
  });

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(_getMapHtml());
  }

  String _getMapHtml() {
    // 마커 JavaScript 코드 생성
    final markersJs = widget.markers.map((place) {
      return '''
        {
          position: new kakao.maps.LatLng(${place.lat}, ${place.lng}),
          title: '${place.name}'
        }
      ''';
    }).join(',');

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Kakao Map</title>
    <style>
        * { margin: 0; padding: 0; }
        html, body { width: 100%; height: 100%; }
        #map { width: 100%; height: 100%; }
    </style>
</head>
<body>
    <div id="map"></div>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${AppConfig.kakaoJavascriptKey}&libraries=services"></script>
    <script>
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(${widget.latitude}, ${widget.longitude}),
            level: ${widget.level}
        };

        var map = new kakao.maps.Map(container, options);

        // 줌 컨트롤 추가
        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 마커 추가
        var markers = [$markersJs];
        
        markers.forEach(function(markerData, index) {
            var marker = new kakao.maps.Marker({
                position: markerData.position,
                title: markerData.title,
                map: map
            });

            // 인포윈도우
            var content = '<div style="padding:5px;font-size:12px;">' + 
                         (index + 1) + '. ' + markerData.title + 
                         '</div>';
            
            var infowindow = new kakao.maps.InfoWindow({
                content: content
            });

            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
        });

        // 지도 클릭 이벤트
        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
            var latlng = mouseEvent.latLng;
            console.log('Map clicked: ' + latlng.getLat() + ', ' + latlng.getLng());
        });

        // 지도 타입 변경 (일반지도, 스카이뷰)
        var mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
