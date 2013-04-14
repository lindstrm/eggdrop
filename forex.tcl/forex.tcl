# $Id: forex.tcl,v 1.0 2013/04/13 $
# Copyright (C) 2013 delete [manellermus@gmail.com]

package require http
package require json

set forexver "1.0"

bind pub -|- !forex forex
proc forex {nick host user chan text} {
    set fields [split $text " "]
    lassign $fields from to value
    set data [json::json2dict [http::data [set t [http::geturl "http://rate-exchange.appspot.com/currency?from=$from&to=$to&q=$value"]]]]
    if {[::http::status $t] != "ok"} { return }
    ::http::cleanup $t
    if {[dict get $data to]!="null"} {
        puthelp "PRIVMSG $chan :Forex: $value[dict get $data from] is [format "%.2f" [dict get $data v]][dict get $data to]"
    } else {
        puthelp "PRIVMSG $chan :No result."
    }

}

putlog "forex.tcl v$forexver loaded"