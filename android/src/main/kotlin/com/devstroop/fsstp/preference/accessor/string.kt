package com.devstroop.fsstp.preference.accessor

import android.content.SharedPreferences
import com.devstroop.fsstp.preference.DEFAULT_STRING_MAP
import com.devstroop.fsstp.preference.OscPrefKey


internal fun getStringPrefValue(key: OscPrefKey, prefs: SharedPreferences): String {
    return prefs.getString(key.name, DEFAULT_STRING_MAP[key]!!)!!
}

internal fun setStringPrefValue(value: String, key: OscPrefKey, prefs: SharedPreferences) {
    prefs.edit().also {
        it.putString(key.name, value)
        it.apply()
    }
}
