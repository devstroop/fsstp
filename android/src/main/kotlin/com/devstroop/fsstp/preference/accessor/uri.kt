package com.devstroop.fsstp.preference.accessor

import android.content.SharedPreferences
import android.net.Uri
import com.devstroop.fsstp.extension.toUri
import com.devstroop.fsstp.preference.DEFAULT_URI_MAP
import com.devstroop.fsstp.preference.OscPrefKey


internal fun getURIPrefValue(key: OscPrefKey, prefs: SharedPreferences): Uri? {
    return prefs.getString(key.name, null)?.toUri() ?: DEFAULT_URI_MAP[key]
}

internal fun setURIPrefValue(value: Uri?, key: OscPrefKey, prefs: SharedPreferences) {
    prefs.edit().also {
        it.putString(key.name, value?.toString() ?: "")
        it.apply()
    }
}
