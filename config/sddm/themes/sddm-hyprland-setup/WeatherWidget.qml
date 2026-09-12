import QtQuick 2.15

Item {
    id: root

    property string city: ""
    property string weatherIcon: "…"
    property string weatherTemp: "--°C"
    property string weatherDesc: ""
    property string weatherWind: ""

    function codeToIcon(code) {
        var c = parseInt(code);
        if (c === 113)
            return "";

        if (c === 116)
            return "󰖕";

        if (c === 119 || c === 122)
            return "󰖐";

        if (c >= 176 && c <= 185)
            return "󰼳";

        if (c >= 200 && c <= 201)
            return "󰙾";

        if (c >= 293 && c <= 353)
            return "󰼳";

        if (c >= 354 && c <= 395)
            return "󰖖";

        return "🌡";
    }

    function fetchLocationAndWeather() {
        if (root.city !== "") {
            fetchWeather(root.city);
            return ;
        }
        var xhrLoc = new XMLHttpRequest();
        xhrLoc.open("GET", "https://ipinfo.io/json", true);
        xhrLoc.onreadystatechange = function() {
            if (xhrLoc.readyState !== XMLHttpRequest.DONE)
                return ;

            if (xhrLoc.status === 200) {
                try {
                    var locData = JSON.parse(xhrLoc.responseText);
                    if (locData.city)
                        root.city = locData.city;

                } catch (e) {
                    console.log("[Weather] Failed to parse ipinfo JSON:", e);
                }
            } else {
                console.log("[Weather] ipinfo request failed, using empty city for wttr.in fallback");
            }
            fetchWeather(root.city);
        };
        xhrLoc.send();
    }

    function fetchWeather(targetCity) {
        var url = "https://wttr.in/" + encodeURIComponent(targetCity) + "?format=j1";
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return ;

            if (xhr.status !== 200) {
                root.weatherDesc = "weather unavailable";
                console.log("[Weather] Failed to fetch wttr.in data");
                return ;
            }
            try {
                var d = JSON.parse(xhr.responseText);
                var c = d.current_condition[0];
                if (d.nearest_area && d.nearest_area[0] && d.nearest_area[0].areaName) {
                    var wttrCity = d.nearest_area[0].areaName[0].value;
                    if (root.city === "")
                        root.city = wttrCity;

                }
                root.weatherIcon = root.codeToIcon(c.weatherCode);
                root.weatherTemp = c.temp_C + "°C";
                root.weatherDesc = c.weatherDesc[0].value;
                root.weatherWind = " " + c.windspeedKmph + " km/h";
            } catch (e) {
                console.log("[Weather] Parse error in wttr.in response:", e);
                root.weatherDesc = "parse error";
            }
        };
        xhr.send();
    }

    width: col.implicitWidth
    height: col.implicitHeight

    Column {
        id: col

        spacing: 4
        anchors.right: parent.right

        Row {
            anchors.right: parent.right
            spacing: 10

            Text {
                text: root.weatherIcon
                font.pixelSize: 34
                color: ThemeColors.accentPrimary
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.weatherTemp
                font.pixelSize: 34
                font.weight: Font.Light
                color: ThemeColors.fgMuted
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        Text {
            text: root.weatherDesc
            font.pixelSize: 12
            color: ThemeColors.fgMuted
            opacity: 0.75
            anchors.right: parent.right
        }

        Text {
            text: root.weatherWind
            font.pixelSize: 12
            font.family: "JetBrainsMono Nerd Font"
            color: ThemeColors.fgMuted
            opacity: 0.55
            anchors.right: parent.right
        }

        Text {
            text: root.city
            font.pixelSize: 11
            font.letterSpacing: 1
            color: ThemeColors.accentPrimary
            opacity: 0.6
            anchors.right: parent.right
        }

    }

    // fetch on startup
    Timer {
        interval: 0
        running: true
        repeat: false
        onTriggered: fetchLocationAndWeather()
    }

    // refresh every 10 minutes
    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: fetchLocationAndWeather()
    }

}
