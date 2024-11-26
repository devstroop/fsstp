package com.devstroop.fsstp.extension

import android.content.SharedPreferences
import com.devstroop.fsstp.preference.TEMP_KEY_HEADER


internal fun SharedPreferences.removeTemporaryPreferences() {
    val editor = edit()

    all.keys.filter { it.startsWith(TEMP_KEY_HEADER) }.forEach { editor.remove(it) }

    editor.apply()
}
