# $Id: twitch.tcl,v 1.0 2013/04/13 $
# Copyright (C) 2013 delete [manellermus@gmail.com]

package require http
package require tls
package require json

set twitchinfover "1.0"

bind pubm -|- {*twitch.tv*} pubm:twitch
proc pubm:twitch {nick host user chan text} {
    if {![regexp {http://(?:[a-z]+\.|)twitch\.tv/([^/]+)} $text {} stream]} { return }
    ::http::register https 443 ::tls::socket
    set data [json::json2dict [http::data [set t [http::geturl "https://api.twitch.tv/kraken/streams/$stream"]]]]
    if {[::http::status $t] != "ok"} { return }
    ::http::cleanup $t
    if {[dict get $data stream]!="null"} {
        puthelp "PRIVMSG $chan :Twitch: [dict get $data stream channel name] -- [dict get $data stream channel status] ([dict get $data stream channel game]), [dict get $data stream viewers] viewers"
    }
}

putlog "twitch.tcl v$twitchinfover loaded"