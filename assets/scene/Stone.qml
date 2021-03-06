import QtQuick 2.2
import "../styles/classic"
import "../styles/neon"

Item {
    id: root
    width: 25
    height: 25
    x: xC - width / 2
    y: yC - height / 2
    property int style: 0
    property int radius: root.width / 2
    property double xC: 0
    property double yC: 0
    property int team: 0
    property double speed: 0
    property double direction: 0
    property double direction_rad: root.direction * Math.PI / 180
    property double angle: 0
    property double f_friction: 0.005
    property double f_curl: 0.02
    property int f_curl_dir: 1
    property double xC_future: 0
    property double yC_future: 0
    rotation: root.angle

    StoneClassic{
        anchors.fill: parent
        team: parent.team
        visible: root.style == 0
    }

    StoneNeon{
        anchors.fill: parent
        team: parent.team
        visible: root.style == 1
    }

    function custom_move(speed, direction) {
        var direction_rad = direction * Math.PI / 180
        xC = xC + speed * Math.cos(direction_rad);
        yC = yC + speed * Math.sin(direction_rad);
    }

    function move() {
        xC = xC + root.speed * Math.cos(direction_rad);
        yC = yC + root.speed * Math.sin(direction_rad);
    }

    function friction(f) {
        var new_speed = root.speed - f
        if (new_speed < 0)
            root.speed = 0
        else
            root.speed = new_speed
    }

    function update() {
        move()
        curl()
        friction(root.f_friction)
    }

    function curl() {
        if (root.speed > 0 && root.f_curl > 0) {
            var fc = root.f_curl_dir *  root.f_curl  * root.speed
            root.direction = root.direction + fc
            root.angle = root.angle + fc * 100
        }
    }

    function prevision() {
        var s = root.speed
        var d = root.direction
        var x = root.xC
        var y = root.yC
        var ff = root.f_friction
        var fc = root.f_curl_dir * root.f_curl * s

        var d_rad = d * Math.PI / 180
        var sx = s * Math.cos(d_rad)
        var sy = s * Math.sin(d_rad)
        var nx = x + 1 / 2 * sx * sx / ff
        var ny = y + 1 / 2 * sy * sy / ff

        root.xC_future = nx
        root.yC_future = ny

        return [nx, ny]
    }
}

